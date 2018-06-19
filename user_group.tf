# userpool/user_group

resource "aws_iam_role" "user_role" {
  name               = "${local.hosted_zone_dash}-user-role"
  assume_role_policy = "${data.aws_iam_policy_document.user_role.json}"

  #   assume_role_policy = <<EOF
  # {
  #   "Version": "2012-10-17",
  #   "Statement": [
  #     {
  #       "Sid": "",
  #       "Effect": "Allow",
  #       "Principal": {
  #         "Federated": "cognito-identity.amazonaws.com"
  #       },
  #       "Action": "sts:AssumeRoleWithWebIdentity",
  #       "Condition": {
  #         "StringEquals": {
  #           "cognito-identity.amazonaws.com:aud": "us-east-1:12345678-dead-beef-cafe-123456790ab"
  #         },
  #         "ForAnyValue:StringLike": {
  #           "cognito-identity.amazonaws.com:amr": "authenticated"
  #         }
  #       }
  #     }
  #   ]
  # }
  # EOF
}

data "aws_iam_policy_document" "user_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = ["us-east-1:xxxxxxxxxxxxxxxxxxx"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

resource "aws_cognito_user_group" "sysadmin_group" {
  name         = "sysadmin"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
  description  = "Managed by Terraform"
  precedence   = 0
  role_arn     = "${aws_iam_role.user_role.arn}"
}

resource "aws_cognito_user_group" "sysuser_group" {
  name         = "sysuser"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
  description  = "Managed by Terraform"
  precedence   = 10
  role_arn     = "${aws_iam_role.user_role.arn}"
}

resource "aws_cognito_user_group" "admin_group" {
  name         = "admin"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
  description  = "Managed by Terraform"
  precedence   = 20
  role_arn     = "${aws_iam_role.user_role.arn}"
}

resource "aws_cognito_user_group" "user_group" {
  name         = "user"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
  description  = "Managed by Terraform"
  precedence   = 30
  role_arn     = "${aws_iam_role.user_role.arn}"
}
