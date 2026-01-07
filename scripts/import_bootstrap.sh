#!/bin/bash
set -euo pipefail

# Required environment variables:
#   AWS_REGION              - AWS region to operate in
#   OIDC_ROLE_TO_ASSUME     - Name of the IAM role to assume for OIDC authentication
#   TF_STATE_S3_BUCKET_NAME - Name of the S3 bucket for Terraform state

# check versions
aws --version
terraform --version

# OIDC provider hostname is a stable constant defined by GitHub and AWS specifications; hardcoded for security and stability reasons
OIDC_PROVIDER_HOSTNAME='token.actions.githubusercontent.com'

# get the AWS account ID
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"


# In Bash, an if statement evaluates the exit status of a command or a
# conditional expression. An exit status of 0 indicates success (true),
# while any non-zero exit status indicates failure (false).


# check if OIDC provider exists before importing
# if it does, import the resources
# if it does not, skip the import
# grep -q will return exit code 0 if the pattern is found, otherwise it returns 1
function import_oidc_provider() {
  if aws iam list-open-id-connect-providers | grep -q "$OIDC_PROVIDER_HOSTNAME"; then
    echo -e "\n\nOIDC provider '$OIDC_PROVIDER_HOSTNAME' exists. Importing...\n\n"
    terraform import 'aws_iam_openid_connect_provider.oidc_gha' "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER_HOSTNAME}"
  else
    echo -e "\n\nOIDC provider '$OIDC_PROVIDER_HOSTNAME' does not exist.  No import needed.\n\n"
  fi
}


# check if role exists before importing
# if it does, import the resources
# if it does not, skip the import
function import_iam_role() {
  if aws iam get-role --role-name "$OIDC_ROLE_TO_ASSUME" > /dev/null 2>&1; then
    echo -e "\n\nIAM role '$OIDC_ROLE_TO_ASSUME' exists. Importing...\n\n"
    terraform import 'aws_iam_role.oidc' "$OIDC_ROLE_TO_ASSUME"
    terraform import 'aws_iam_role_policy_attachments_exclusive.oidc' "$OIDC_ROLE_TO_ASSUME"
  else
    echo -e "\n\nIAM role '$OIDC_ROLE_TO_ASSUME' does not exist.  No import needed.\n\n"
  fi
}


# check if bucket exists before importing
# if it does, import the resources
# if it does not, skip the import
function import_tf_state_bucket() {
  local account_id="$1"
  local region="$2"
  local tf_state_bucket_name="terraform-state-${account_id}-${region}"
  local region_underscore="${region//-/_}"

  if aws s3api head-bucket --bucket "$tf_state_bucket_name" --region "$region" > /dev/null 2>&1; then
    echo -e "\n\nBucket '$tf_state_bucket_name' exists. Importing...\n\n"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket.terraform_state_bucket" "$tf_state_bucket_name"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket_public_access_block.terraform_state_bucket" "$tf_state_bucket_name"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket_versioning.terraform_state_bucket" "$tf_state_bucket_name"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket_lifecycle_configuration.terraform_state_bucket" "$tf_state_bucket_name"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket_server_side_encryption_configuration.terraform_state_bucket" "$tf_state_bucket_name"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket_ownership_controls.terraform_state_bucket" "$tf_state_bucket_name"
    terraform import "module.tf_state_bucket_${region_underscore}.aws_s3_bucket_policy.terraform_state_bucket" "$tf_state_bucket_name"
  else
    echo -e "\n\nBucket '$tf_state_bucket_name' does not exist.  No import needed.\n\n"
  fi
}


# main
echo -e "\n\nStarting import of existing AWS resources into Terraform state...\n\n"

echo "::group::import oidc provider:"
import_oidc_provider
echo "::endgroup::"

echo "::group::import iam role:"
import_iam_role
echo "::endgroup::"

echo "::group::import bucket(us-east-2):"
import_tf_state_bucket "$AWS_ACCOUNT_ID" "us-east-2"
echo "::endgroup::"

echo "::group::import bucket(us-east-1):"
import_tf_state_bucket "$AWS_ACCOUNT_ID" "us-east-1"
echo "::endgroup::"

echo "::group::import bucket(ca-central-1):"
import_tf_state_bucket "$AWS_ACCOUNT_ID" "ca-central-1"
echo "::endgroup::"
