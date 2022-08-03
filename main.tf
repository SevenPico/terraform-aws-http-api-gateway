// -----------------------------------------------------------------------------
// HTTP API Gateway
// -----------------------------------------------------------------------------
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
  credentials_arn              = null # quick-create only
  route_key                    = null # quick-create only
  target                       = null # quick-create only
  api_key_selection_expression = null # websocket only
}

locals {
  api_id = one(aws_apigatewayv2_api.this[*].id)
}


// -----------------------------------------------------------------------------
// Integrations
// -----------------------------------------------------------------------------
# aws_apigatewayv2_integration
# aws_apigatewayv2_integration_response


    # api_id - (Required) The API identifier.
    # integration_type - (Required) The integration type of an integration. Valid values: AWS (supported only for WebSocket APIs), AWS_PROXY, HTTP (supported only for WebSocket APIs), HTTP_PROXY, MOCK (supported only for WebSocket APIs). For an HTTP API private integration, use HTTP_PROXY.
    # connection_id - (Optional) The ID of the VPC link for a private integration. Supported only for HTTP APIs. Must be between 1 and 1024 characters in length.
    # connection_type - (Optional) The type of the network connection to the integration endpoint. Valid values: INTERNET, VPC_LINK. Default is INTERNET.
    # content_handling_strategy - (Optional) How to handle response payload content type conversions. Valid values: CONVERT_TO_BINARY, CONVERT_TO_TEXT. Supported only for WebSocket APIs.
    # credentials_arn - (Optional) The credentials required for the integration, if any.
    # description - (Optional) The description of the integration.
    # integration_method - (Optional) The integration's HTTP method. Must be specified if integration_type is not MOCK.
    # integration_subtype - (Optional) Specifies the AWS service action to invoke. Supported only for HTTP APIs when integration_type is AWS_PROXY. See the AWS service integration reference documentation for supported values. Must be between 1 and 128 characters in length.
    # integration_uri - (Optional) The URI of the Lambda function for a Lambda proxy integration, when integration_type is AWS_PROXY. For an HTTP integration, specify a fully-qualified URL. For an HTTP API private integration, specify the ARN of an Application Load Balancer listener, Network Load Balancer listener, or AWS Cloud Map service.
    # passthrough_behavior - (Optional) The pass-through behavior for incoming requests based on the Content-Type header in the request, and the available mapping templates specified as the request_templates attribute. Valid values: WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER. Default is WHEN_NO_MATCH. Supported only for WebSocket APIs.
    # payload_format_version - (Optional) The format of the payload sent to an integration. Valid values: 1.0, 2.0. Default is 1.0.
    # request_parameters - (Optional) For WebSocket APIs, a key-value map specifying request parameters that are passed from the method request to the backend. For HTTP APIs with a specified integration_subtype, a key-value map specifying parameters that are passed to AWS_PROXY integrations. For HTTP APIs without a specified integration_subtype, a key-value map specifying how to transform HTTP requests before sending them to the backend. See the Amazon API Gateway Developer Guide for details.
    # request_templates - (Optional) A map of Velocity templates that are applied on the request payload based on the value of the Content-Type header sent by the client. Supported only for WebSocket APIs.
    # response_parameters - (Optional) Mappings to transform the HTTP response from a backend integration before returning the response to clients. Supported only for HTTP APIs.
    # template_selection_expression - (Optional) The template selection expression for the integration.
    # timeout_milliseconds - (Optional) Custom timeout between 50 and 29,000 milliseconds for WebSocket APIs and between 50 and 30,000 milliseconds for HTTP APIs. The default timeout is 29 seconds for WebSocket APIs and 30 seconds for HTTP APIs. Terraform will only perform drift detection of its value when present in a configuration.
    # tls_config - (Optional) The TLS configuration for a private integration. Supported only for HTTP APIs.

# The response_parameters object supports the following:

    # status_code - (Required) The HTTP status code in the range 200-599.
    # mappings - (Required) A key-value map. The key of ths map identifies the location of the request parameter to change, and how to change it. The corresponding value specifies the new data for the parameter. See the Amazon API Gateway Developer Guide for details.

# The tls_config object supports the following:

    # server_name_to_verify - (Optional) If you specify a server name, API Gateway uses it to verify the hostname on the integration's certificate. The server name is also included in the TLS handshake to support Server Name Indication (SNI) or virtual hosting.


// -----------------------------------------------------------------------------
// Routes
// -----------------------------------------------------------------------------
#    aws_apigatewayv2_route
#    aws_apigatewayv2_route_response








// -----------------------------------------------------------------------------
// VPC Links
// -----------------------------------------------------------------------------
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









// -----------------------------------------------------------------------------
// Authorizers
// -----------------------------------------------------------------------------
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



// -----------------------------------------------------------------------------
// Models
// -----------------------------------------------------------------------------
#    aws_apigatewayv2_model

// -----------------------------------------------------------------------------
// Deployment
// -----------------------------------------------------------------------------
#    aws_apigatewayv2_deployment
#    aws_apigatewayv2_stage


// -----------------------------------------------------------------------------
// DNS
// -----------------------------------------------------------------------------
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
  api_mapping_key = null # websocket
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
