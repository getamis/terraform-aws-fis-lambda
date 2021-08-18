# Cloudwatch publish as cron trigger

resource "aws_cloudwatch_event_rule" "fis" {
  name                = var.name
  description         = "${var.name} fis cronjob trigger"
  schedule_expression = var.cloudwatch_event_rule_schedule_expression

  tags = merge(var.extra_tags, tomap({
    Name      = var.name
    BuiltWith = "terraform"
  }))
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.fis.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.fis.arn
}

# sns

resource "aws_sns_topic" "fis" {
  name              = var.name
  kms_master_key_id = var.sns_topic_kms_key_id

  tags = merge(var.extra_tags, tomap({
    Name      = var.name
    BuiltWith = "terraform"
  }))
}

resource "aws_sns_topic_policy" "fis" {
  arn    = aws_sns_topic.fis.arn
  policy = data.aws_iam_policy_document.sns.json
}

data "aws_iam_policy_document" "sns" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.fis.arn]
  }
}

# Cloudwatch subscription

resource "aws_sns_topic_subscription" "fis" {
  topic_arn  = aws_sns_topic.fis.arn
  protocol   = "lambda"
  endpoint   = module.lambda.lambda_function_arn
}
