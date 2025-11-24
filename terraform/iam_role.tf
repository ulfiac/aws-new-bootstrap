data "aws_iam_policy_document" "assume_role_policy_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_hostname}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${var.oidc_provider_hostname}:sub"
      values = [
        "repo:ulfiac/aws-bootstrap:*",
        "repo:ulfiac/aws-new-bootstrap:*"
      ]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_gha.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "oidc" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_oidc.json
  name               = var.oidc_role_to_assume
}

resource "aws_iam_role_policy_attachments_exclusive" "oidc" {
  role_name = aws_iam_role.oidc.name
  policy_arns = [
    data.aws_iam_policy.admin_access.arn,
    data.aws_iam_policy.billing.arn
  ]
}
