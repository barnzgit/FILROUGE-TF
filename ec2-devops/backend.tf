terraform {
  backend "s3" {
    bucket = "barnz-filrouge"
    key    = "tf/devops.tfstate"
    region = "eu-west-3"
  }
}