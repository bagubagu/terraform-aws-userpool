# userpool/identity_pool_authenticated

resource "aws_iam_role" "authenticated" {
  name = "${local.hosted_zone_dash}-authenticated"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authenticated" {
  name = "${local.hosted_zone_dash}-authenticated-policy"
  role = "${aws_iam_role.authenticated.id}"

  policy = "${data.aws_iam_policy_document.authenticated_policy.json}"
}

data "aws_iam_policy_document" "authenticated_policy" {
  statement {
    effect    = "Allow"
    actions   = ["mobileanalytics:PutEvents", "cognito-sync:*", "cognito-identity:*"]
    resources = ["*"]
  }
}
