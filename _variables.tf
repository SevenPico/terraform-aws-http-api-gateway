variable "description" {
  type = string
  default = ""
}


variable "disable_execute_api_endpoint" {
  type = bool
  default = true
}


variable "fail_on_warnings" {
  type = bool
  default = false
}


variable "route_selection_expression" {
  type = string
  default = ""
}


variable "version" {
  type = string
  default = "0.0.1"
}

variable "cors_configuration" {
  type = object({
    allow_credentials = optional(bool)         # (Optional) Whether credentials are included in the CORS request.
    allow_headers     = optional(map(string))  # (Optional) The set of allowed HTTP headers.
    allow_methods     = optional(list(string)) # (Optional) The set of allowed HTTP methods.
    allow_origins     = optional(list(string)) # (Optional) The set of allowed origins.
    expose_headers    = optional(map(string))  # (Optional) The set of exposed HTTP headers.
    max_age           = optional(number)       # (Optional) The number of seconds that the browser should cache preflight request results.
  })
}

variable "targets" {
  type = list(object({
    type                          = string
    method                        = string
    vpc_link_key                  = optional(string)
    request_parameters            = optional(map(bool))
    response_parameters           = optional(map(number)) # FIXME
    credentials_arn               = optional(string)
    content_handling_strategy     = optional(string)
    description                   = optional(string)
    payload_format_version        = optional(string)
    template_selection_expression = optional(string)
    server_name_to_verify         = optional(string)
    subtype                       = optional(string)
    uri                           = optional(string)
    tls_config                    = optional(string)
  }))
}

variable "routes" {
  type = list(object({
    key                        = string
    authorizer_key             = optional(string)
    model_selection_expression = optional(string)
    operation_name             = optional(string)
    target_key                 = optional(string)
    request_parameters         = optional(map(bool))
    response = optional(object({
      route_response_key         = optional(string)
      model_selection_expression = optional(string)
      response_models            = optional(any)
    }))
  }))
}

variable "authorizers" {
  type = list(object({
    key                     = string
    type                    = string
    credentials_arn         = optional(string)
    payload_format_version  = optional(string)
    result_ttl_in_seconds   = optional(number)
    uri                     = optional(string)
    enable_simple_responses = optional(bool)
    identity_sources        = optional(string)
    jwt_configuration = optional(object({
      audience = list(string)
      issuer   = string
    }))
  }))
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

