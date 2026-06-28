terraform {
  backend "s3" {
    bucket       = "shopflow-tf-state-114223852322-us-east-1-an"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
