#!/bin/bash
set -euo pipefail

# Required environment variables:
#   OIDC_PROVIDER_HOSTNAME  - Hostname of the OIDC provider for GitHub Actions
#   OIDC_ROLE_TO_ASSUME     - Name of the IAM role to assume for OIDC authentication
#   TF_STATE_S3_BUCKET_NAME - Name of the S3 bucket for Terraform state

# check versions
aws --version
terraform --version

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
  if aws iam list-open-id-connect-providers | grep -q "$OIDC_PROVIDER_HOSTNAME" > /dev/null 2>&1; then
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
# if it does, import the resouces
# if it does not, skip the import
function import_s3_bucket() {
  if aws s3api head-bucket --bucket "$TF_STATE_S3_BUCKET_NAME" > /dev/null 2>&1; then
    echo -e "\n\nBucket '$TF_STATE_S3_BUCKET_NAME' exists. Importing...\n\n"
    terraform import 'aws_s3_bucket.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
    terraform import 'aws_s3_bucket_public_access_block.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
    terraform import 'aws_s3_bucket_versioning.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
    terraform import 'aws_s3_bucket_lifecycle_configuration.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
    terraform import 'aws_s3_bucket_server_side_encryption_configuration.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
    terraform import 'aws_s3_bucket_ownership_controls.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
    terraform import 'aws_s3_bucket_policy.terraform_state' "$TF_STATE_S3_BUCKET_NAME"
  else
    echo -e "\n\nBucket '$TF_STATE_S3_BUCKET_NAME' does not exist.  No import needed.\n\n"
  fi
}


# main execution
import_oidc_provider
import_iam_role
import_s3_bucket
