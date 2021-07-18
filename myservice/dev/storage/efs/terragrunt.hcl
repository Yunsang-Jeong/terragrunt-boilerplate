include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/Yunsang-Jeong/terraform-aws-efs?ref=v1.0.0"
}

dependency "vpc" {
  config_path = "${path_relative_from_include()}/myservice/dev/network/vpc/"
  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
    subnet_ids = {
      "private-was-a" = "subnet-00000000000000000"
      "private-was-c" = "subnet-00000000000000000"
    }
  }
}

dependency "security_group" {
  config_path = "${path_relative_from_include()}/myservice/dev/security/security-group/"
  mock_outputs = {
    security_group_ids = {
      "efs" = "sg-00000000000000000"
    }
  }
}

inputs = {
  ########################################
  # Shared
  global_additional_tag = {}
  ########################################

  ########################################
  # AWS EFS
  name_tag_postfix = "myservice"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  ########################################

  ########################################
  # Mounting EFS
  subnet_ids = [
    lookup(dependency.vpc.outputs.subnet_ids, "private-was-a"),
    lookup(dependency.vpc.outputs.subnet_ids, "private-was-c")
  ]
  security_group_ids = [
    lookup(dependency.security_group.outputs.security_group_ids, "efs")
  ]
  ########################################
}
