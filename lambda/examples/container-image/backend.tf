terraform {
  backend "s3" {
    bucket = "tfstate-bucket-poc-000"
    key    = "lambda/tf.state"
    region = "eu-west-1"
  }
}
