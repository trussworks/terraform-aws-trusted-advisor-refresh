locals {
  pkg  = "truss-aws-tools"
  name = "trusted-advisor-refresh"
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

# The AWS partition (commercial or govcloud)
data "aws_partition" "current" {
}

#
# IAM
#

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "main" {
  # Allow creating and writing CloudWatch logs for Lambda function.
  statement {
    sid = "WriteCloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.name}-${var.environment}:*"]
  }

  # Allow access to support APIs. Unfortunately, IAM doesn't provide
  # all the necessary per API actions needed for this tool. So we
  # need to provide full access to support.
  statement {
    sid    = "TrustedAdvisorRefresh"
    effect = "Allow"

    actions = [
      "support:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "main" {
  name               = "lambda-${local.name}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "main" {
  name = "lambda-${local.name}-${var.environment}"
  role = aws_iam_role.main.id

  policy = data.aws_iam_policy_document.main.json
}

#
# CloudWatch Scheduled Event
#

resource "aws_cloudwatch_event_rule" "main" {
  name                = "${local.name}-${var.environment}"
  description         = "scheduled trigger for ${local.name}"
  schedule_expression = "rate(${var.interval_minutes} minutes)"
}

resource "aws_cloudwatch_event_target" "main" {
  rule = aws_cloudwatch_event_rule.main.name
  arn  = aws_lambda_function.main.arn
}

#
# CloudWatch Logs
#

resource "aws_cloudwatch_log_group" "main" {
  # This name must match the lambda function name and should not be changed
  name              = "/aws/lambda/${local.name}-${var.environment}"
  retention_in_days = var.cloudwatch_logs_retention_days

  tags = {
    Name        = "${local.name}-${var.environment}"
    Environment = var.environment
  }

  # set the key, else empty string
  kms_key_id = var.cloudwatch_encryption_key_arn
}

#
# Lambda Function
#

resource "aws_lambda_permission" "main" {
  statement_id = "${local.name}-${var.environment}"

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name

  principal  = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.main.arn
}

resource "aws_lambda_function" "main" {
  depends_on = [aws_cloudwatch_log_group.main]

  s3_bucket = var.s3_bucket
  s3_key    = "${local.pkg}/${var.version_to_deploy}/${local.pkg}.zip"

  function_name = "${local.name}-${var.environment}"
  role          = aws_iam_role.main.arn
  handler       = local.name
  runtime       = "go1.x"
  memory_size   = "128"
  timeout       = "60"

  environment {
    variables = {
      LAMBDA = "true"
    }
  }

  tags = {
    Name        = "${local.name}-${var.environment}"
    Environment = var.environment
  }
}
