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
  default = "$request.method $request.path"
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
  default     = 7
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
  #   integration_key         = string
  #   authorizer_key          = optional(string)
  #   operation_name          = optional(string)
  # }))
  default = {}
}

variable "integrations" {
  type = map(any)
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

variable "stage_variables" {
  type = map(string)
  default = {}
}


variable "access_log_format" {
  description = "Format for CloudWatch access logs."
  type        = string
  default = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
}




