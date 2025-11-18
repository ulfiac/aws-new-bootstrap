locals {
  account_id = data.aws_caller_identity.current.account_id

  # OIDC provider hostname is a stable constant defined by GitHub and AWS specifications; hardcoded for security and stability reasons
  oidc_provider_hostname = "token.actions.githubusercontent.com"
}
