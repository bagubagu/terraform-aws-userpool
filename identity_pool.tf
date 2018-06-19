# userpool/identity_pool

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "Dev Persi Identity Pool"
  allow_unauthenticated_identities = true
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = "${aws_cognito_identity_pool.main.id}"

  roles {
    "authenticated"   = "${aws_iam_role.authenticated.arn}"
    "unauthenticated" = "${aws_iam_role.unauthenticated.arn}"
  }
}

resource "aws_iam_role" "unauthenticated" {
  name = "${local.hosted_zone_dash}-unauthenticated"

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
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}

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

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "unauthenticated" {
  name = "${local.hosted_zone_dash}-unauthenticated-policy"
  role = "${aws_iam_role.unauthenticated.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
