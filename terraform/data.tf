data "aws_caller_identity" "current" {}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

data "aws_iam_policy" "billing" {
  name = "Billing"
}
