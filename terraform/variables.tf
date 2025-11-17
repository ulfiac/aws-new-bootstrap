variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "oidc_role_to_assume" {
  description = "The name of the IAM role to be assumed by OIDC-auth'ed Github Actions."
  type        = string
}

variable "oidc_provider_hostname" {
  description = "The hostname of the OIDC provider for Github Actions."
  type        = string
}

variable "tf_state_s3_bucket_name" {
  description = "The name of the s3 bucket for terraform state(s)."
  type        = string
}
