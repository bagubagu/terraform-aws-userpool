# userpool/userpool_client.tf

resource "aws_cognito_user_pool_client" "client" {
  name         = "my_client"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"

  # default_redirect_uri = "localhost:4200"
  callback_urls                        = ["localhost:4200"]
  logout_urls                          = ["localhost:4200"]
  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true

  supported_identity_providers = [
    "COGNITO",
    "Google",
  ]

  allowed_oauth_flows = [
    "code",
    "implicit",
  ]

  allowed_oauth_scopes = [
    "phone",
    "email",
    "openid",
    "profile",
    "aws.cognito.signin.user.admin",
  ]

  #   explicit_auth_flows = [
  #     "ADMIN_NO_SRP_AUTH",
  #     "CUSTOM_AUTH_FLOW_ONLY",
  #     "USER_PASSWORD_AUTH",
  #   ]

  #   read_attributes              = []
  #   write_attributes             = []
  #   refresh_token_validity       = 7
}
