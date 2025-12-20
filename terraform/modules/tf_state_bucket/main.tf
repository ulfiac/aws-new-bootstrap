locals {
  aws_account_id              = data.aws_caller_identity.current.account_id
  aws_region                  = data.aws_region.current.region
  terraform_state_bucket_name = "terraform-state-${local.aws_account_id}-${local.aws_region}"
}
