data "aws_iam_policy_document" "fis" {
  statement {
    sid = "AllowStartExperimentTemplate"

    actions = [
      "fis:StartExperiment"
    ]

    resources = [
      for s in var.lambda_allowed_experiment_template_ids : "arn:aws:fis:*:*:experiment-template/${s}"
    ]
  }

  statement {
    sid = "AllowStartExperiment"

    actions = [
      "fis:StartExperiment",
      "fis:TagResource",
      "fis:UntagResource"
    ]

    resources = [
      "arn:aws:fis:ap-southeast-1:196434174575:experiment/*"
    ]
  }
}

resource "aws_iam_policy" "fis" {
  name        = var.name
  path        = "/"
  description = "FIS policy for lambda"
  policy      = data.aws_iam_policy_document.fis.json
}

resource "aws_iam_role_policy_attachment" "fis" {
  policy_arn = aws_iam_policy.fis.arn
  role       = module.lambda.lambda_role_name
}

