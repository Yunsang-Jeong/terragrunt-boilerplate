include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/Yunsang-Jeong/terraform-aws-ec2-profile?ref=v1.0.0"
}

inputs = {
  ec2_profiles = [{
    identifier = "bastion"
    name_tag_postfix = "bastion"
  },{
    identifier = "web"
    name_tag_postfix = "web"
  },{
    identifier = "was"
    name_tag_postfix = "was"
  }]

  attach_managed_policy = [{
    profile_identifier = "bastion"
    managed_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  },{
    profile_identifier = "web"
    managed_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  },{
    profile_identifier = "was"
    managed_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }]
}