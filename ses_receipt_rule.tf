# userpool/ses_receipt_rule

resource "aws_ses_receipt_rule" "incoming_email" {
  name          = "${local.hosted_zone_dash}-incoming-email-rule"
  rule_set_name = "default-rule-set"
  recipients    = ["${var.hosted_zone}", ".${var.hosted_zone}"]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = "${aws_s3_bucket.incoming_email.id}"
    position    = 1
  }
}

resource "aws_s3_bucket" "incoming_email" {
  region        = "${var.region}"
  bucket        = "${local.hosted_zone_dash}-incoming-email"
  force_destroy = "${var.force_destroy}"
}

resource "aws_s3_bucket_policy" "incoming_email" {
  bucket = "${aws_s3_bucket.incoming_email.id}"
  policy = "${data.aws_iam_policy_document.incoming_email.json}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "incoming_email" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.incoming_email.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }
  }
}
