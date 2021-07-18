include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/Yunsang-Jeong/terraform-aws-cache-redis?ref=v1.0.0"
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
      "redis-session" = "sg-00000000000000000"
    }
  }
}

inputs = {
  ########################################
  # Shared
  global_additional_tag = {}
  ########################################

  apply_immediately = true

  ########################################
  # AWS ElastiCache for redis
  replication_group_id = "session-clustering"
  replication_group_description = "Session clustering for web service"

  engine_version = "6.x"
  port = 6379

  node_type = "cache.r5.xlarge"
  multi_az_enabled = true
  # availability_zones = []

  automatic_failover_enabled = true
  cluster_mode = {
    num_node_groups = 1
    replicas_per_node_group = 2
  }
  
  security_group_ids = [
    lookup(dependency.security_group.outputs.security_group_ids, "redis-session")
  ]
  ########################################

  ########################################
  # Parameter group
  parameter_group_family = "redis6.x"
  parameter_group_description = "Session clustering for web service"
  # parameter_group_values = []
  ########################################

  ########################################
  # Subnet group
  subnet_group_description = "Session clustering for web service"
  subnet_ids = [
    lookup(dependency.vpc.outputs.subnet_ids, "private-was-a"),
    lookup(dependency.vpc.outputs.subnet_ids, "private-was-c")
  ]
  ########################################
}