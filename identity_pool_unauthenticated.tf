# userpool/identity_pool_unauthenticated

resource "aws_iam_role" "unauthenticated" {
  name               = "${local.hosted_zone_dash}-unauthenticated"
  assume_role_policy = "${data.aws_iam_policy_document.unauthenticated.json}"
}

resource "aws_iam_role_policy" "unauthenticated" {
  name = "${local.hosted_zone_dash}-unauthenticated-policy"
  role = "${aws_iam_role.unauthenticated.id}"

  policy = "${data.aws_iam_policy_document.unauthenticated_policy.json}"
}

data "aws_iam_policy_document" "unauthenticated" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = ["${aws_cognito_identity_pool.main.id}"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }

    principals {
      # type        = "Service"
      type        = "Federated"
      identifiers = ["cognito-idp.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "unauthenticated_policy" {
  statement {
    effect    = "Allow"
    actions   = ["mobileanalytics:PutEvents", "cognito-sync:*"]
    resources = ["*"]
  }
}
