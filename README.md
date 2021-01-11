Creates an AWS Lambda function to update Trusted Advisor
on a scheduled interval using [truss-aws-tools](https://github.com/trussworks/truss-aws-tools).

Creates the following resources:

* IAM role for Lambda function to access Trusted Advisor.
* CloudWatch Event to trigger function on a schedule.
* AWS Lambda function to actually call Trusted Advisor APIs.

## Terraform Versions

Terraform 0.13 and later. Pin module version to ~> 3.0.0. Submit pull-requests to master branch.

Terraform 0.12. Pin module version to ~> 2.0.0. Submit pull-requests to terraform011 branch.

## Usage

```hcl
module "trusted-advisor-refresh" {
  source  = "trussworks/trusted-advisor-refresh/aws"
  version = "1.0.0"

  environment       = "prod"
  interval_minutes  = "5"
  s3_bucket         = "lambda-builds-us-east-1"
  version_to_deploy = "1.0"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_logs\_retention\_days | Number of days to keep logs in AWS CloudWatch. | `string` | `90` | no |
| environment | Environment tag, e.g prod. | `any` | n/a | yes |
| interval\_minutes | How often to update Trusted Advisor. | `string` | `60` | no |
| s3\_bucket | The name of the S3 bucket used to store the Lambda builds. | `string` | n/a | yes |
| version\_to\_deploy | The version the Lambda function to deploy. | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
