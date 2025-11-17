resource "aws_iam_openid_connect_provider" "oidc_gha" {
  client_id_list = ["sts.amazonaws.com"]
  url            = "https://${var.oidc_provider_hostname}"
}
