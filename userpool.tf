# userpool/userpool

# resource "aws_iam_role" "main" {
#   name = "${local.hosted_zone_dash}-lambda"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_lambda_function" "main" {
#   filename      = "lambda.zip"
#   function_name = "terraform-example"
#   role          = "${aws_iam_role.main.arn}"
#   handler       = "exports.example"
#   runtime       = "nodejs4.3"
# }

resource "aws_iam_role" "cidp" {
  name               = "${local.hosted_zone_dash}-cidp"
  path               = "/service-role/"
  assume_role_policy = "${data.aws_iam_policy_document.cidp.json}"
}

data "aws_iam_policy_document" "cidp" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["88888888"]
    }

    principals {
      type        = "Service"
      identifiers = ["cognito-idp.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "main" {
  name   = "${local.hosted_zone_dash}-idp-policy"
  role   = "${aws_iam_role.cidp.id}"
  policy = "${data.aws_iam_policy_document.sns.json}"
}

data "aws_iam_policy_document" "sns" {
  statement {
    effect    = "Allow"
    actions   = ["sns:publish"]
    resources = ["*"]
  }
}

resource "aws_cognito_user_pool" "pool" {
  name                       = "${local.hosted_zone_dash}"
  mfa_configuration          = "OPTIONAL"
  auto_verified_attributes   = ["phone_number", "email"]
  alias_attributes           = ["phone_number", "email", "preferred_username"]
  sms_authentication_message = "Your authentication code is {####}"
  sms_verification_message   = "Your verification code is {####}"

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  email_configuration {
    reply_to_email_address = "support@persi.id"
    source_arn             = "arn:aws:ses:us-east-1:340967951063:identity/support@persi.id"
  }

  sms_configuration {
    external_id    = "88888888"
    sns_caller_arn = "${aws_iam_role.cidp.arn}"
  }

  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = false
  }

  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  # email_verification_message = "<a href=\"https://XXXXXX/confirm?username={username}&amp;code={####}\">Click here to verify your email address.</a>"
  verification_message_template {
    # default_email_option = "CONFIRM_WITH_CODE"
    default_email_option = "CONFIRM_WITH_LINK"

    # email_message         = "Your verification code is {####}"
    email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##}"

    # email_subject         = "Your verification code"
    email_subject_by_link = "Your verification link"

    # sms_message           = "Your verification code is {####}"
  }

  schema {
    name                     = "custom-x"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false

    string_attribute_constraints {
      min_length = 7
      max_length = 15
    }
  }

  tags = {}

  # lambda_config {
  #   create_auth_challenge          = "${aws_lambda_function.main.arn}"
  #   custom_message                 = "${aws_lambda_function.main.arn}"
  #   define_auth_challenge          = "${aws_lambda_function.main.arn}"
  #   post_authentication            = "${aws_lambda_function.main.arn}"
  #   post_confirmation              = "${aws_lambda_function.main.arn}"
  #   pre_authentication             = "${aws_lambda_function.main.arn}"
  #   pre_sign_up                    = "${aws_lambda_function.main.arn}"
  #   pre_token_generation           = "${aws_lambda_function.main.arn}"
  #   user_migration                 = "${aws_lambda_function.main.arn}"
  #   verify_auth_challenge_response = "${aws_lambda_function.main.arn}"
  # }
}
