variable "description" {
  type    = string
  default = ""
}

variable "disable_execute_api_endpoint" {
  type    = bool
  default = true
}


variable "fail_on_warnings" {
  type    = bool
  default = false
}


variable "route_selection_expression" {
  type    = string
  default = ""
}


variable "api_version" {
  type    = string
  default = "0.0.1"
}

variable "cloudwatch_logs_retention_in_days" {
  description = <<EOF
  Specifies the number of days you want to retain log events in the specified log group. Possible values are:
  1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the
  log group are always retained and never expire.
  EOF
  type        = number
  default     = 0
}

variable "cors_configuration" {
  type = any
  # type = object({
  #   allow_credentials = optional(bool)
  #   allow_headers     = optional(list(string))
  #   allow_methods     = optional(list(string))
  #   allow_origins     = optional(list(string))
  #   expose_headers    = optional(list(string))
  #   max_age           = optional(number)
  # })
  default = null
}

variable "routes" {
  type = map(any)
  # type = map(object({
  #   type                    = string
  #   authorizer_key          = optional(string)
  #   operation_name          = optional(string)
  #   credentials_arn         = optional(string)
  #   payload_format_version  = optional(string)
  #   result_ttl_in_seconds   = optional(number)
  #   uri                     = optional(string)
  #   enable_simple_responses = optional(bool)
  #   identity_sources        = optional(string)
  #   jwt_configuration = optional(object({
  #     audience = list(string)
  #     issuer   = string
  #   }))
  #   # TODO
  #   # response = optional(object({
  #   #   route_response_key = optional(string)
  #   #   response_models    = optional(any)
  #   # }))
  # }))
  default = {}
}

variable "authorizers" {
  type = map(any)
  # type = map(object({
  #   type                    = string
  #   credentials_arn         = optional(string)
  #   payload_format_version  = optional(string)
  #   result_ttl_in_seconds   = optional(number)
  #   uri                     = optional(string)
  #   enable_simple_responses = optional(bool)
  #   identity_sources        = optional(string)
  #   jwt_configuration = optional(object({
  #     audience = list(string)
  #     issuer   = string
  #   }))
  # }))
  default = {}
}

variable "vpc_links" {
  type = map(object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  }))
  default = {}
}


variable "dns_enabled" {
  type    = bool
  default = false
}

variable "dns_name" {
  type        = string
  default     = ""
  description = "Required if dns_enabled is true."
}

variable "zone_id" {
  type        = string
  default     = ""
  description = "Required if dns_enabled is true."
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "Required if dns_enabled is true."
}

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Trigger new depoloyment on update to API."
}

variable "access_log_format" {
  description = "Format for CloudWatch access logs."
  type        = string
  default = " {\n\t\"requestTime\": \"$context.requestTime\",\n\t\"requestId\": \"$context.requestId\",\n\t\"httpMethod\": \"$context.httpMethod\",\n\t\"path\": \"$context.path\",\n\t\"resourcePath\": \"$context.resourcePath\",\n\t\"status\": $context.status,\n\t\"responseLatency\": $context.responseLatency,\n \"xrayTraceId\": \"$context.xrayTraceId\",\n \"integrationRequestId\": \"$context.integration.requestId\",\n\t\"functionResponseStatus\": \"$context.integration.status\",\n \"integrationLatency\": \"$context.integration.latency\",\n\t\"integrationServiceStatus\": \"$context.integration.integrationStatus\",\n \"authorizeResultStatus\": \"$context.authorize.status\",\n\t\"authorizerServiceStatus\": \"$context.authorizer.status\",\n\t\"authorizerLatency\": \"$context.authorizer.latency\",\n\t\"authorizerRequestId\": \"$context.authorizer.requestId\",\n \"ip\": \"$context.identity.sourceIp\",\n\t\"userAgent\": \"$context.identity.userAgent\",\n\t\"principalId\": \"$context.authorizer.principalId\",\n\t\"cognitoUser\": \"$context.identity.cognitoIdentityId\",\n \"user\": \"$context.identity.user\"\n}\n"
}

variable "stage_variables" {
  type = map(string)
  default = {}
}
