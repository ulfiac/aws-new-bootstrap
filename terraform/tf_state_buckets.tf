module "tf_state_bucket_us_east_2" {
  source = "./modules/tf_state_bucket"

  providers = {
    aws = aws
  }
}

module "tf_state_bucket_us_east_1" {
  source = "./modules/tf_state_bucket"

  providers = {
    aws = aws.us_east_1
  }
}

module "tf_state_bucket_ca_central_1" {
  source = "./modules/tf_state_bucket"

  providers = {
    aws = aws.ca_central_1
  }
}
