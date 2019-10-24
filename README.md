<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates an AWS Lambda function to update Trusted Advisor
on a scheduled interval using [truss-aws-tools](https://github.com/trussworks/truss-aws-tools).

Creates the following resources:

* IAM role for Lambda function to access Trusted Advisor.
* CloudWatch Event to trigger function on a schedule.
* AWS Lambda function to actually call Trusted Advisor APIs.

## Usage

```hcl
module "trusted_advisor_refresh" {
  source = "../../modules/aws-trusted-advisor-refresh"

  environment       = "prod"
  interval_minutes  = "5"
  s3_bucket         = "lambda-builds-us-east-1"
  version_to_deploy = "1.0"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudwatch\_logs\_retention\_days | Number of days to keep logs in AWS CloudWatch. | string | `"90"` | no |
| environment | Environment tag, e.g prod. | string | n/a | yes |
| interval\_minutes | How often to update Trusted Advisor. | string | `"60"` | no |
| s3\_bucket | The name of the S3 bucket used to store the Lambda builds. | string | n/a | yes |
| version\_to\_deploy | The version the Lambda function to deploy. | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
