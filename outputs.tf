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

output "user_pool_domain_cloudfront_distribution_arn" {
  value = "${aws_cognito_user_pool_domain.main.cloudfront_distribution_arn}"
}

output "user_pool_domain_s3_bucket" {
  value = "${aws_cognito_user_pool_domain.main.s3_bucket}"
}
