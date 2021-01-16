locals {
  domain_name = "example.com" # trimsuffix(data.aws_route53_zone.this.name, ".")
  subdomain   = "complete-http"
}

module "api_gateway" {
  source = "../apigateway"

  name          = "${random_pet.this.id}-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  create_api_domain_name         = false
  create_routes_and_integrations = true


  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_function_from_container_image.this_lambda_function_invoke_arn
      integration_uri        = module.lambda_function_from_container_image.this_lambda_function_invoke_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.lambda_function_from_container_image.this_lambda_function_invoke_arn
    }

  }

  tags = {
    Name = "dev-api-new"
  }
}

######
# ACM
######

# data "aws_route53_zone" "this" {
#   name = local.domain_name
# }

# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "~> 2.0"

#   domain_name               = local.domain_name
#   zone_id                   = data.aws_route53_zone.this.id
#   subject_alternative_names = ["${local.subdomain}.${local.domain_name}"]
# }

# ##########
# # Route53
# ##########

# resource "aws_route53_record" "api" {
#   zone_id = data.aws_route53_zone.this.zone_id
#   name    = local.subdomain
#   type    = "A"

#   alias {
#     name                   = module.api_gateway.this_apigatewayv2_domain_name_configuration[0].target_domain_name
#     zone_id                = module.api_gateway.this_apigatewayv2_domain_name_configuration[0].hosted_zone_id
#     evaluate_target_health = false
#   }
# }

##################
# Extra resources
##################lan

resource "aws_cloudwatch_log_group" "logs" {
  name = random_pet.this.id
}
