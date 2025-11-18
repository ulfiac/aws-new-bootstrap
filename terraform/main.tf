locals {
  account_id = data.aws_caller_identity.current.account_id

  oidc_provider_hostname = "token.actions.githubusercontent.com"

  tf_state_s3_bucket_name = "tf-state-${local.account_id}-${var.aws_region}"
}
