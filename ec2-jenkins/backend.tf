terraform {
  backend "s3" {
    bucket = "barnz-filrouge"
    key    = "tf/jenkins.tfstate"
    region = "eu-west-3"
  }
}