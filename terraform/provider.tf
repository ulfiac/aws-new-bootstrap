module "tags" {
  # tflint-ignore: terraform_module_pinned_source
  source  = "git::https://github.com/ulfiac/infra.git//terragrunt/_modules/tags?ref=main"
  project = "aws-bootstrap"
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = module.tags.all_the_tags
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = module.tags.all_the_tags
  }
}

provider "aws" {
  alias  = "ca_central_1"
  region = "ca-central-1"

  default_tags {
    tags = module.tags.all_the_tags
  }
}
