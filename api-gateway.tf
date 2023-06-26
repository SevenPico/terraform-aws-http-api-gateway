# -----------------------------------------------------------------------------
# HTTP API Gateway
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_api" "this" {
  count = module.context.enabled ? 1 : 0

  protocol_type                = "HTTP"
  name                         = module.context.id
  tags                         = module.context.tags
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  fail_on_warnings             = var.fail_on_warnings
  route_selection_expression   = var.route_selection_expression

  body                         = null # don't use
  api_key_selection_expression = null # websocket only
  credentials_arn              = null # quick-create only
  route_key                    = null # quick-create only
  target                       = null # quick-create only

  dynamic "cors_configuration" {
    for_each = toset(var.cors_configuration != null ? [1] : [])
    content {
      allow_credentials = try(var.cors_configuration.allow_credentials, null)
      allow_headers     = try(var.cors_configuration.allow_headers, null)
      allow_methods     = try(var.cors_configuration.allow_methods, null)
      allow_origins     = try(var.cors_configuration.allow_origins, null)
      expose_headers    = try(var.cors_configuration.expose_headers, null)
      max_age           = try(var.cors_configuration.max_age, null)
    }
  }
}

locals {
  api_id = one(aws_apigatewayv2_api.this[*].id)
}


# -----------------------------------------------------------------------------
# Routes
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_route" "this" {
  for_each = module.context.enabled ? var.routes : {}

  api_id               = local.api_id
  authorization_scopes = try(var.authorizers[each.value.authorizer_key].scopes, null)
  authorization_type   = try(var.authorizers[each.value.authorizer_key].type, null) == "REQUEST" ? "CUSTOM" : try(var.authorizers[each.value.authorizer_key].type, null)
  authorizer_id        = try(aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id, null)
  operation_name       = try(each.value.operation_name, null)
  route_key            = each.key
  target               = "integrations/${aws_apigatewayv2_integration.this[each.value.integration_key].id}"

  api_key_required                    = null # websocket only
  model_selection_expression          = null # websocket only
  request_models                      = null # websocket only
  route_response_selection_expression = null # websocket only
}


# -----------------------------------------------------------------------------
# Integrations
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_integration" "this" {
  for_each = module.context.enabled ? var.integrations : {}

  api_id                        = local.api_id
  integration_type              = each.value.type
  connection_type               = can(each.value.vpc_link_key) ? "VPC_LINK" : "INTERNET"
  connection_id                 = can(each.value.vpc_link_key) ? aws_apigatewayv2_vpc_link.this[each.value.vpc_link_key].id : null
  credentials_arn               = try(each.value.credentials_arn, null)
  description                   = try(each.value.description, null)
  integration_method            = try(each.value.method, null)
  integration_subtype           = try(each.value.subtype, null)
  integration_uri               = try(each.value.uri, null)
  request_parameters            = try(each.value.request_parameters, null)
  payload_format_version        = try(each.value.payload_format_version, null)
  template_selection_expression = try(each.value.template_selection_expression, null)
  timeout_milliseconds          = try(each.value.timeout_milliseconds, null)

  # TODO
  # response_parameters           = try(each.value.response_parameters, null)

  dynamic "tls_config" {
    for_each = toset(can(each.value.tls_config) ? [1] : [])
    content {
      server_name_to_verify = each.value.tls_config.server_name_to_verify
    }
  }

  request_templates         = null # websocket only
  content_handling_strategy = null # websocket only
  passthrough_behavior      = null # websocket only
}

# -----------------------------------------------------------------------------
# Responses
# -----------------------------------------------------------------------------
# TODO
# aws_apigatewayv2_route_response
# aws_apigatewayv2_integration_response


# -----------------------------------------------------------------------------
# VPC Links
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = module.context.enabled ? var.vpc_links : {}

  name               = each.key
  security_group_ids = [module.vpc_link_security_group[each.key].id]
  subnet_ids         = each.value.subnet_ids
  tags               = module.context.tags
}

module "vpc_link_security_group" {
  for_each = module.context.enabled ? var.vpc_links : {}

  source  = "app.terraform.io/SevenPico/vpc/aws//modules/security-group"
  version = "0.0.2"

  allow_all_egress              = true
  create_before_destroy         = true
  inline_rules_enabled          = false
  revoke_rules_on_delete        = false
  rule_matrix                   = []
  rules                         = []
  security_group_create_timeout = "10m"
  security_group_delete_timeout = "15m"
  security_group_description    = "API Gateway VPC Link: ${each.key}"
  security_group_name           = []
  target_security_group_id      = []
  vpc_id                        = each.value.vpc_id

  rules_map = {
    ingress-https-from-internet = [{
      description = "Allow ingress from internet"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
      protocol    = "tcp"
      from_port   = var.dns_name == "" ? 443 : 80
      to_port     = var.dns_name == "" ? 443 : 80
    }]
  }
}


# -----------------------------------------------------------------------------
# Authorizers
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_authorizer" "this" {
  for_each = module.context.enabled ? var.authorizers : {}

  api_id                            = local.api_id
  authorizer_type                   = each.value.type
  name                              = each.key
  authorizer_credentials_arn        = try(each.value.credentials_arn, null)
  authorizer_payload_format_version = try(each.value.payload_format_version, null)
  authorizer_result_ttl_in_seconds  = try(each.value.result_ttl_in_seconds, null)
  authorizer_uri                    = try(each.value.uri, null)
  enable_simple_responses           = try(each.value.enable_simple_responses, null)
  identity_sources                  = try(each.value.identity_sources, null)

  dynamic "jwt_configuration" {
    for_each = toset(can(each.value.jwt_configuration) ? [1] : [])
    content {
      audience = each.value.jwt_configuration.audience
      issuer   = each.value.jwt_configuration.issuer
    }
  }
}


# -----------------------------------------------------------------------------
# Models
# -----------------------------------------------------------------------------
# TODO
# aws_apigatewayv2_model


# -----------------------------------------------------------------------------
# Stage
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_stage" "this" {
  count = module.context.enabled ? 1 : 0

  api_id                = local.api_id
  auto_deploy           = var.enable_auto_deploy
  deployment_id         = var.enable_auto_deploy ? one(aws_apigatewayv2_deployment.this[*].id) : null
  description           = var.description
  name                  = "$default"
  stage_variables       = var.stage_variables
  tags                  = module.context.tags
  client_certificate_id = null # websocket only

  dynamic "access_log_settings" {
    for_each = toset(var.access_logging_enabled ? [1] : [])
    content {
      destination_arn = one(aws_cloudwatch_log_group.this[*].arn)
      format          = var.access_log_format
    }
  }

  # FIXME - null defaults don't work
  # default_route_settings {
  #   detailed_metrics_enabled = null # TODO
  #   throttling_burst_limit   = null # TODO
  #   throttling_rate_limit    = null # TODO
  #   data_trace_enabled       = null # websocket only
  #   logging_level            = null # websocket only
  # }
}

resource "aws_cloudwatch_log_group" "this" {
  count = module.context.enabled && var.access_logging_enabled ? 1 : 0

  name              = "/aws/vendedlogs/apigateway/${module.context.id}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  tags              = module.context.tags
}


# -----------------------------------------------------------------------------
# Deployment
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_deployment" "this" {
  count = module.context.enabled && !var.enable_auto_deploy ? 1 : 0

  api_id      = local.api_id
  description = var.description
  triggers = {
    redeployment = sha1(join(",", [
      jsonencode(aws_apigatewayv2_integration.this),
      jsonencode(aws_apigatewayv2_route.this),
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


# -----------------------------------------------------------------------------
# DNS
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_domain_name" "this" {
  count = module.context.enabled ? 1 : 0

  domain_name = var.dns_name
  tags        = module.context.tags

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
  count = module.context.enabled ? 1 : 0

  api_id          = local.api_id
  api_mapping_key = null # websocket only
  domain_name     = one(aws_apigatewayv2_domain_name.this[*].domain_name)
  stage           = one(aws_apigatewayv2_stage.this[*].id)
}

resource "aws_route53_record" "this" {
  count = module.context.enabled ? var.route53_zone_ids_count : 0

  name    = one(aws_apigatewayv2_domain_name.this[*].domain_name)
  type    = "A"
  zone_id = var.route53_zone_ids[count.index]

  alias {
    name                   = one(aws_apigatewayv2_domain_name.this[*].domain_name_configuration[0].target_domain_name)
    zone_id                = one(aws_apigatewayv2_domain_name.this[*].domain_name_configuration[0].hosted_zone_id)
    evaluate_target_health = false
  }
}
