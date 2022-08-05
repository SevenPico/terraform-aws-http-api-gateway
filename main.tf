# -----------------------------------------------------------------------------
# HTTP API Gateway
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_api" "this" {
  count = module.meta.enabled ? 1 : 0

  protocol_type                = "HTTP"
  name                         = module.meta.id
  tags                         = module.meta.tags
  cors_configuration           = var.cors_configuration
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  fail_on_warnings             = var.fail_on_warnings
  route_selection_expression   = var.route_selection_expression
  version                      = var.version

  body                         = null # don't use
  api_key_selection_expression = null # websocket only
  credentials_arn              = null # quick-create only
  route_key                    = null # quick-create only
  target                       = null # quick-create only
}

locals {
  api_id = one(aws_apigatewayv2_api.this[*].id)
}


# -----------------------------------------------------------------------------
# Integrations
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_integration" "this" {
  for_each = toset(module.this.enabled ? var.integrations : [])

  api_id                        = local.api_id
  integration_type              = each.type
  connection_type               = can(each.value.vpc_link_key) ? "VPC_LINK" : "INTERNET"
  connection_id                 = try(each.value.type, "") == "VPC_LINK" ? aws_apigatewayv2_vpc_link.this[each.value.vpc_link_key].id : null
  credentials_arn               = try(each.value.credentials_arn, null)
  description                   = try(each.value.description, null)
  integration_method            = try(each.value.method, null)
  integration_subtype           = try(each.value.subtype, null)
  integration_uri               = try(each.value.uri, null)
  request_parameters            = try(each.value.request_parameters, null)
  response_parameters           = try(each.value.response_parameters, null)
  payload_format_version        = try(each.value.payload_format_version, null)
  template_selection_expression = try(each.value.template_selection_expression, null)
  timeout_milliseconds          = try(each.value.timeout_milliseconds, null)
  tls_config                    = try(each.value.tls_config, null)

  request_templates         = null # websocket only
  content_handling_strategy = null # websocket only
  passthrough_behavior      = null # websocket only
}

# TODO
# resource "aws_apigatewayv2_integration_response" "this" {
#   api_id - (Required) The API identifier.
#   integration_id - (Required) The identifier of the aws_apigatewayv2_integration.
#   integration_response_key - (Required) The integration response key.
#   content_handling_strategy - (Optional) How to handle response payload content type conversions. Valid values: CONVERT_TO_BINARY, CONVERT_TO_TEXT.
#   response_templates - (Optional) A map of Velocity templates that are applied on the request payload based on the value of the Content-Type header sent by the client.
#   template_selection_expression - (Optional) The template selection expression for the integration response.
# }


# -----------------------------------------------------------------------------
# Routes
# -----------------------------------------------------------------------------
#    aws_apigatewayv2_route
#    aws_apigatewayv2_route_response


# -----------------------------------------------------------------------------
# VPC Links
# -----------------------------------------------------------------------------
# resource "aws_apigatewayv2_vpc_link" "this" {
#   name               = "example"
#   security_group_ids = [data.aws_security_group.example.id]
#   subnet_ids         = data.aws_subnet_ids.example.ids

#   tags = {
#     Usage = "example"
#   }
# }

# Argument Reference

# The following arguments are supported:

#     name - (Required) The name of the VPC Link. Must be between 1 and 128 characters in length.
#     security_group_ids - (Required) Security group IDs for the VPC Link.
#     subnet_ids - (Required) Subnet IDs for the VPC Link.
#     tags - (Optional) A map of tags to assign to the VPC Link. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.



# -----------------------------------------------------------------------------
# Authorizers
# -----------------------------------------------------------------------------
# resource "aws_apigatewayv2_authorizer" "this" {
#   for_each = var.authorizers
# }

# api_id - (Required) The API identifier.
# authorizer_type - (Required) The authorizer type. Valid values: JWT, REQUEST. Specify REQUEST for a Lambda function using incoming request parameters. For HTTP APIs, specify JWT to use JSON Web Tokens.
# name - (Required) The name of the authorizer. Must be between 1 and 128 characters in length.
# authorizer_credentials_arn - (Optional) The required credentials as an IAM role for API Gateway to invoke the authorizer. Supported only for REQUEST authorizers.
# authorizer_payload_format_version - (Optional) The format of the payload sent to an HTTP API Lambda authorizer. Required for HTTP API Lambda authorizers. Valid values: 1.0, 2.0.
# authorizer_result_ttl_in_seconds - (Optional) The time to live (TTL) for cached authorizer results, in seconds. If it equals 0, authorization caching is disabled. If it is greater than 0, API Gateway caches authorizer responses. The maximum value is 3600, or 1 hour. Defaults to 300. Supported only for HTTP API Lambda authorizers.
# authorizer_uri - (Optional) The authorizer's Uniform Resource Identifier (URI). For REQUEST authorizers this must be a well-formed Lambda function URI, such as the invoke_arn attribute of the aws_lambda_function resource. Supported only for REQUEST authorizers. Must be between 1 and 2048 characters in length.
# enable_simple_responses - (Optional) Whether a Lambda authorizer returns a response in a simple format. If enabled, the Lambda authorizer can return a boolean value instead of an IAM policy. Supported only for HTTP APIs.
# identity_sources - (Optional) The identity sources for which authorization is requested. For REQUEST authorizers the value is a list of one or more mapping expressions of the specified request parameters. For JWT authorizers the single entry specifies where to extract the JSON Web Token (JWT) from inbound requests.
# jwt_configuration - (Optional) The configuration of a JWT authorizer. Required for the JWT authorizer type. Supported only for HTTP APIs.

# The jwt_configuration object supports the following:

# audience - (Optional) A list of the intended recipients of the JWT. A valid JWT must provide an aud that matches at least one entry in this list.
# issuer - (Optional) The base domain of the identity provider that issues JSON Web Tokens, such as the endpoint attribute of the aws_cognito_user_pool resource.

# Attributes Reference

# In addition to all arguments above, the following attributes are exported:

# id - The authorizer identifier.



# -----------------------------------------------------------------------------
# Models
# -----------------------------------------------------------------------------
#    aws_apigatewayv2_model


# -----------------------------------------------------------------------------
# Deployment
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_deployment" "this" {
  count = module.this.enabled ? 1 : 0

  api_id      = local.api_id
  description = var.description
  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_apigatewayv2_integration.this),
      jsonencode(aws_apigatewayv2_route.this),
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}



# -----------------------------------------------------------------------------
# Stage
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_stage" "this" {
  count = module.this.enabled ? 1 : 0

  api_id = local.api_id
  name = module.this.id
  deployment_id = one(aws_apigatewayv2_deployment.this[*].id)
  description = var.description

  tags = module.this.tags

  route_settings = {
    route_key                = // (Required) Route key.
    data_trace_enabled       = // (Optional) Whether data trace logging is enabled for the route. Affects the log entries pushed to Amazon CloudWatch Logs. Defaults to false. Supported only for WebSocket APIs.
    detailed_metrics_enabled = // (Optional) Whether detailed metrics are enabled for the route. Defaults to false.
    logging_level            = // (Optional) The logging level for the route. Affects the log entries pushed to Amazon CloudWatch Logs. Valid values: ERROR, INFO, OFF. Defaults to OFF. Supported only for WebSocket APIs. Terraform will only perform drift detection of its value when present in a configuration.
    throttling_burst_limit   = // (Optional) The throttling burst limit for the route.
    throttling_rate_limit    = // (Optional) The throttling rate limit for the route.
  }

  access_log_settings = {
    destination_arn = one(aws_cloudwatch_log_group.this[*].arn)
    format = var.access_log_format
  }
}

# auto_deploy - (Optional) Whether updates to an API automatically trigger a new deployment. Defaults to false. Applicable for HTTP APIs.
# client_certificate_id - (Optional) The identifier of a client certificate for the stage. Use the aws_api_gateway_client_certificate resource to configure a client certificate. Supported only for WebSocket APIs.
# stage_variables - (Optional) A map that defines the stage variables for the stage.

# access_log_settings - (Optional) Settings for logging access in this stage. Use the aws_api_gateway_account resource to configure permissions for CloudWatch Logging.
# The access_log_settings object supports the following:


# default_route_settings - (Optional) The default route settings for the stage.
# The default_route_settings object supports the following:
# data_trace_enabled - (Optional) Whether data trace logging is enabled for the default route. Affects the log entries pushed to Amazon CloudWatch Logs. Defaults to false. Supported only for WebSocket APIs.
# detailed_metrics_enabled - (Optional) Whether detailed metrics are enabled for the default route. Defaults to false.
# logging_level - (Optional) The logging level for the default route. Affects the log entries pushed to Amazon CloudWatch Logs. Valid values: ERROR, INFO, OFF. Defaults to OFF. Supported only for WebSocket APIs. Terraform will only perform drift detection of its value when present in a configuration.
# throttling_burst_limit - (Optional) The throttling burst limit for the default route.
# throttling_rate_limit - (Optional) The throttling rate limit for the default route.

# -----------------------------------------------------------------------------
# Cloudwatch Logs
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "this" {
  count = module.this.enabled ? 1 : 0

  name              = "/aws/apigateway/${module.this.id}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  tags              = module.this.tags
}


# -----------------------------------------------------------------------------
# DNS
# -----------------------------------------------------------------------------
module "dns_meta" {
  source     = "registry.terraform.io/cloudposse/label/null"
  version    = "0.25.0"
  context    = module.meta.context
  enabled    = module.meta.enabled && var.dns_enabled
  attributes = ["dns"]
}

resource "aws_apigatewayv2_domain_name" "this" {
  count = module.dns_meta.enabled ? 1 : 0

  domain_name = var.dns_name
  tags        = module.dns_meta.tags

  domain_name_configuration {
    certificate_arn                        = var.acm_certificate_arn
    endpoint_type                          = "REGIONAL"
    security_policy                        = "TLS_1_2"
    ownership_verification_certificate_arn = null
  }

  timeouts {
    create = "10m"
    update = "10m"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count = module.dns_meta.enabled ? 1 : 0

  api_id          = local.api_id
  api_mapping_key = null # websocket only
  domain_name     = one(aws_apigatewayv2_domain_name.this[*].domain_name)
  stage           = one(aws_apigatewayv2_stage.this[*].id) # FIXME
}

resource "aws_route53_record" "this" {
  count = module.dns_meta.enabled ? 1 : 0

  name    = one(aws_apigatewayv2_domain_name.this[*].domain_name)
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = one(aws_apigatewayv2_domain_name.this[*].domain_name_configuration[0].target_domain_name)
    zone_id                = one(aws_apigatewayv2_domain_name.this[*].domain_name_configuration[0].hosted_zone_id)
    evaluate_target_health = false
  }
}
