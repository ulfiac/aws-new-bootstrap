provider "aws" {
  region = var.aws_region

  default_tags {
    tags = module.tags.all_the_tags
  }
}

module "tags" {
  # tflint-ignore: terraform_module_pinned_source
  source  = "git::https://github.com/ulfiac/aws-tags.git"
  project = "aws-bootstrap"
  additional_tags = {
    bootstrap_layer = "root_layer"
  }
}
