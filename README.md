# Overview

Terrgrunt에 대한 기본적인 틀에 대한 내용입니다. `myservice`라는 이름의 서비스를 프로비저닝합니다. 서비스의 환경별 구성은 다음과 같습니다.
```bash
├── region.hcl
├── stage.hcl
├── network
│   └── terragrunt.hcl
├── security
│   ├── ec2-profile
│   │   └── terragrunt.hcl
│   └── security-group
│       └── terragrunt.hcl
├── service
└── storage
    ├── cache-redis
    │   └── terragrunt.hcl
    └── efs
        └── terragrunt.hcl
```
> service에 대한 구성은 생략했습니다.

## How-to-use

다음의 항목에 대해 설치가 되어 있거나 실행이 가능해야합니다.
 - git
 - terraform (>= 0.14.0)
 - terragrunt

`./myservice` 하위 디렉토리에서 상황에 맞게 다음과 같이 실행할 수 있습니다.
```bash
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

혹은 특정 리소스 디렉토리에서(예를 들어, `./myservice/prd/network/vpc/`) 다음과 같이 실행할 수 있습니다.
```bash
terragrunt run init
terragrunt run plan
terragrunt run apply
```

## Configuration

다음과 같은 항목에 대해 수정이 필요합니다.

**terragrunt.hcl**
 - state를 저장할 AWS S3 버킷에 대한 정보
 - lock을 위한 AWS Dynamodb table 이름
```hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region = "ap-northeast-2"
    bucket = "state를 저장할 AWS S3 버킷에 대한 정보"
    key    = "terraform-state/${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "lock을 위한 AWS Dynamodb table 이름"
    encrypt        = true
  }
}
```

**account.hcl**
 - 프로비저닝에 사용할 AWS Account의 정보
```hcl
locals {
  aws_profile = "default"
  # aws_region = ""
  # aws_accesskey = ""
  # aws_secretkey = ""
  # aws_assume_role_arn = ""
  # aws_assume_session_name = ""
  # aws_allowed_account_ids = []
}
```

**project.hcl**
 - project의 이름
```hcl
locals {
  project_name = "myservice"
}
```

**/dev/region.hcl, /prd/region.hcl**
 - 리소스가 프로비저닝될 대상 AWS Region의 정보
```hcl
locals {
  region_l = "ap-northeast-2"
  region_s = "an2"
}
```

**/dev/stage.hcl, /prd/stage.hcl**
 - 서비스의 stage에 해당 정보입니다.
```hcl
locals {
  stage = "prd"
}
```