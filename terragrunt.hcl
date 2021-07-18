skip = true
terragrunt_version_constraint = ">= 0.30"
terraform_version_constraint  = ">= 0.14.0"

locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project_name = lookup(local.project_vars.locals, "project_name")

  stage_vars = read_terragrunt_config(find_in_parent_folders("stage.hcl"))
  stage      = lookup(local.stage_vars.locals, "stage")

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile("aws_provider.tpl", {
    "aws_region"              = lookup(local.region_vars.locals, "region_l")
    "aws_profile"             = lookup(local.account_vars.locals, "aws_profile", "")
    "aws_accesskey"           = lookup(local.account_vars.locals, "aws_accesskey", "")
    "aws_secretkey"           = lookup(local.account_vars.locals, "aws_secretkey", "")
    "aws_assume_role_arn"     = lookup(local.account_vars.locals, "aws_assume_role_arn", "")
    "aws_assume_session_name" = lookup(local.account_vars.locals, "aws_assume_session_name", "terragrunt")
    "aws_allowed_account_ids" = []
  })
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region = "ap-northeast-2"
    bucket = ""
    key    = "terraform-state/${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = ""
    encrypt        = true
  }
}

inputs = {
  name_tag_convention = {
    stage        = local.stage
    project_name = local.project_name
  }
}