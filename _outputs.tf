output "execution_arn" {
  value = try(aws_apigatewayv2_api.this[0].execution_arn, "")
}

output "api_endpoint" {
  value = try(aws_apigatewayv2_api.this[0].api_endpoint, "")
}

output "arn" {
  value = try(aws_apigatewayv2_api.this[0].arn, "")
}

output "id" {
  value = try(aws_apigatewayv2_api.this[0].id, "")
}

output "domain_name" {
  value = try(aws_apigatewayv2_domain_name.this[0].domain_name, "")
}

output "regional_domain_name" {
  value = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, "")
}

output "regional_zone_id" {
  value = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, "")
}
