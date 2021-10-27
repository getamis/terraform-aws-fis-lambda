module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.8.0"

  function_name                  = var.name
  description                    = "${var.name} lambda function to trigger fis"
  handler                        = "handler.lambda_handler" # python
  source_path                    = "${path.module}/functions"
  runtime                        = "python3.8"
  timeout                        = var.lambda_timeout
  kms_key_arn                    = var.kms_key_arn
  reserved_concurrent_executions = var.reserved_concurrent_executions

  # If publish is disabled, there will be "Error adding new Lambda Permission for notify_slack: InvalidParameterValueException: We currently do not support adding policies for $LATEST."
  publish = true

  environment_variables     = var.lambda_environment_variables

  create_role               = var.lambda_role == ""
  lambda_role               = var.lambda_role
  role_name                 = var.name
  role_permissions_boundary = var.iam_role_boundary_policy_arn
  role_tags                 = var.iam_role_tags

  attach_network_policy     = var.lambda_function_vpc_subnet_ids != null

  allowed_triggers = {
    AllowExecutionFromSNS = {
      principal  = "sns.amazonaws.com"
      source_arn = aws_sns_topic.fis.arn
    }
  }

  store_on_s3 = var.lambda_function_store_on_s3
  s3_bucket   = var.lambda_function_s3_bucket

  vpc_subnet_ids         = var.lambda_function_vpc_subnet_ids
  vpc_security_group_ids = var.lambda_function_vpc_security_group_ids

  tags = merge(var.extra_tags, tomap({
    Name      = var.name
    BuiltWith = "terraform"
  }))
}
