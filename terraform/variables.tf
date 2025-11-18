variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "oidc_role_to_assume" {
  description = "The name of the IAM role to be assumed by OIDC-auth'ed Github Actions."
  type        = string
}
