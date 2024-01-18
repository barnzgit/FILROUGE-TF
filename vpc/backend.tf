terraform {
  backend "s3" {
    bucket = "barnz-filrouge"
    key    = "tf/vpc.tfstate"
    region = "eu-west-3"
  }
}