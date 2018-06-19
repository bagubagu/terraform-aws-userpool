# userpool/ses
resource "aws_ses_domain_identity" "domain" {
  domain = "${var.hosted_zone}"
}

resource "aws_ses_domain_identity_verification" "domain_verification" {
  domain     = "${aws_ses_domain_identity.domain.id}"
  depends_on = ["aws_route53_record.txt"]
}

data "aws_route53_zone" "domain" {
  name = "${var.hosted_zone}."
}

resource "aws_route53_record" "txt" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "_amazonses.${aws_ses_domain_identity.domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = ["${aws_ses_domain_identity.domain.verification_token}"]
}

#------------------------------------------------------------------
# DANGER, Will Robinson!! this will override your email MX setting.
#------------------------------------------------------------------
# resource "aws_route53_record" "mx" {
#   zone_id = "${data.aws_route53_zone.domain.zone_id}"
#   name    = "${var.hosted_zone}"
#   type    = "MX"
#   ttl     = "600"
#   records = ["10 inbound-smtp.us-east-1.amazonaws.com"]
# }

resource "aws_ses_domain_dkim" "domain" {
  domain = "${aws_ses_domain_identity.domain.domain}"
}

resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${element(aws_ses_domain_dkim.domain.dkim_tokens, count.index)}._domainkey.${var.hosted_zone}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.domain.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
