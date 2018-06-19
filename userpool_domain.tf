# userpool/userpool_domain

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${local.hosted_zone_dash}"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}
