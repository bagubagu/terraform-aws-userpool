output "user_pool_id" {
  value = "${aws_cognito_user_pool.pool.id}"
}

output "user_pool_arn" {
  value = "${aws_cognito_user_pool.pool.arn}"
}

output "identity_pool_id" {
  value = "${aws_cognito_identity_pool.main.id}"
}

output "identity_pool_arn" {
  value = "${aws_cognito_identity_pool.main.arn}"
}

output "user_pool_client_id" {
  value = "${aws_cognito_user_pool_client.client.id}"
}

output "user_pool_client_secret" {
  value = "${aws_cognito_user_pool_client.client.client_secret}"
}

output "user_pool_domain_url" {
  value = "https://${local.hosted_zone_dash}.auth.us-east-1.amazoncognito.com"
}
