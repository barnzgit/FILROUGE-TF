terraform {
  backend "s3" {
    bucket = "barnz-filrouge"
    key    = "tf/eks.tfstate"
    region = "eu-west-3"
  }
}