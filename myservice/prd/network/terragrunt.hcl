include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/Yunsang-Jeong/terraform-aws-network?ref=v1.0.0"
}

inputs = {
  vpc_cidr_block = "10.10.8.0/21"
  create_igw = true
  subnets = [
    {
      identifier            = "public-a"
      name_tag_postfix      = "pub-a"
      availability_zone     = "ap-northeast-2a"
      cidr_block            = "10.10.8.0/24"
      enable_route_with_igw = true
      create_nat            = true
    },
    {
      identifier            = "public-c"
      name_tag_postfix      = "pub-c"
      availability_zone     = "ap-northeast-2c"
      cidr_block            = "10.10.9.0/24"
      enable_route_with_igw = true
    },
    {
      identifier            = "private-web-a"
      name_tag_postfix      = "pri-web-a"
      availability_zone     = "ap-northeast-2a"
      cidr_block            = "10.10.10.0/24"
      enable_route_with_nat = true
    },
    {
      identifier            = "private-web-c"
      name_tag_postfix      = "pri-web-c"
      availability_zone     = "ap-northeast-2c"
      cidr_block            = "10.10.11.0/24"
      enable_route_with_nat = true
    },
    {
      identifier            = "private-was-a"
      name_tag_postfix      = "pri-was-a"
      availability_zone     = "ap-northeast-2a"
      cidr_block            = "10.10.12.0/24"
      enable_route_with_nat = true
    },
    {
      identifier            = "private-was-c"
      name_tag_postfix      = "pri-was-c"
      availability_zone     = "ap-northeast-2c"
      cidr_block            = "10.10.13.0/24"
      enable_route_with_nat = true
    },
    {
      identifier        = "private-db-a"
      name_tag_postfix  = "pri-db-a"
      availability_zone = "ap-northeast-2a"
      cidr_block        = "10.10.14.0/24"
    },
    {
      identifier        = "private-db-c"
      name_tag_postfix  = "pri-db-c"
      availability_zone = "ap-northeast-2c"
      cidr_block        = "10.10.15.0/24"
    }
  ]
}
