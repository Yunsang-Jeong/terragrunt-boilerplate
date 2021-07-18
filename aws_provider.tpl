provider "aws" {
  region  = "${aws_region}"
  %{if aws_profile != ""}
  profile = "${aws_profile}"
  %{endif}
  %{if aws_accesskey != "" && aws_secretkey != ""}
  access_key = "${aws_accesskey}"
  secret_key = "${aws_secretkey}"
  %{endif}
  %{if aws_assume_role_arn != "" && aws_assume_session_name != ""}
  assume_role {
    role_arn     = "${aws_assume_role_arn}"
    session_name = "${aws_assume_session_name}"
  }
  %{endif}
  %{if aws_allowed_account_ids != []}
  allowed_account_ids = [%{ for id in aws_allowed_account_ids ~} "${id}", %{ endfor ~}]
  %{endif}
}