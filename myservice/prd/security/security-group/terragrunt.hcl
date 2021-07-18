include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${path_relative_from_include()}/myservice/prd/network/vpc/"
  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
  }
}

terraform {
  source = "github.com/Yunsang-Jeong/terraform-aws-scg?ref=v1.0.0"
}

inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  security_groups     = [
  ########################################
  # Bastion instnace
  {
    identifier       = "ec2-bastion"
    name_tag_postfix = "ec2-bastion"
    description      = "ec2-bastion"
    ingresses = [{
      description = "public"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  ########################################

  ########################################
  # ALB for web
  {
    identifier       = "alb-web"
    name_tag_postfix = "alb-web"
    description      = "alb-web"
    ingresses = [{
      description = "public"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  ########################################

  ########################################
  # Web instance
  {
    identifier       = "ec2-web"
    name_tag_postfix = "ec2-web"
    description      = "ec2-web"
    ingresses = [{
      description = "from bastion"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      source_security_group_identifier = "ec2-bastion"
      },{
      description = "from alb"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      source_security_group_identifier = "alb-web"
      }
    ]
  },

  ########################################
  # ALB for was
  {
    identifier       = "alb-was"
    name_tag_postfix = "alb-was"
    description      = "alb-was"
    ingresses = [{
      description = "from web instance"
      from_port   = "8080"
      to_port     = "8080"
      protocol    = "tcp"
      source_security_group_identifier = "ec2-web"
      }
    ]
  },
  ########################################

  ########################################
  # Was instance
  {
    identifier       = "ec2-was"
    name_tag_postfix = "ec2-was"
    description      = "ec2-was"
    ingresses = [{
      description = "from bastion"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      source_security_group_identifier = "ec2-bastion"
      },{
      description = "from alb"
      from_port   = "8080"
      to_port     = "8080"
      protocol    = "tcp"
      source_security_group_identifier = "alb-was"
      }
    ]
  },
  ########################################

  ########################################
  # AWS ElastiCache for redis
  {
    identifier       = "redis-session"
    name_tag_postfix = "redis-session"
    description      = "redis-session"
    ingresses = [{
      description = "Service"
      from_port   = "6379"
      to_port     = "6379"
      protocol    = "tcp"
      self        = true
      }
    ]
  },
  ########################################

  ########################################
  # AWS EFS
  {
    identifier       = "efs"
    name_tag_postfix = "efs"
    description      = "efs"
    ingresses = [{
      description = "Service"
      from_port   = "2049"
      to_port     = "2049"
      protocol    = "tcp"
      self        = true
      }
    ]
  },
  ########################################
  ]
}