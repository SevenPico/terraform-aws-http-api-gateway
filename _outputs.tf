
# one(aws_apigatewayv2_api.this[*].id)
# one(aws_apigatewayv2_api.this[*].api_endpoint)
# one(aws_apigatewayv2_api.this[*].arn)
# one(aws_apigatewayv2_api.this[*].execution_arn)
# one(aws_apigatewayv2_api.this[*].tags_all)

#resource "aws_apigatewayv2_domain_name" "this" {
# api_mapping_selection_expression - API mapping selection expression for the domain name.
# arn - ARN of the domain name.
# id - Domain name identifier.
# tags_all - Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.


# id - The API mapping identifier.
# resource "aws_apigatewayv2_api_mapping" "this" {


#resource "aws_apigatewayv2_deployment" "this" {
# id - The deployment identifier.
# auto_deployed - Whether the deployment was automatically released.
