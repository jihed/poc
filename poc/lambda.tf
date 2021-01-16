provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "random_pet" "this" {
  length = 2
}

module "lambda_function_from_container_image" {
  source = "../lambda"

  function_name = "${random_pet.this.id}-lambda-from-container-image"
  description   = "My awesome lambda function from container image"

  create_package = false
  publish        = true

  ##################
  # Container Image
  ##################
  image_uri    = docker_registry_image.app.name
  package_type = "Image"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.this_apigatewayv2_api_execution_arn}/*/*/"
    }
  }
}
