variable "lambda_arn" { type = string }

# ! Part 1 - Create a rule on the "default" Event Bridge to invoke
# ! the input Lambda once every minute using the native resources
# ! provided by the AWS provider.
# resource "aws_cloudwatch_event_rule" "this" {
# 	description         = "retry scheuled every 1 minute"
# 	name                = "profile-generator-lambda-event-rule"
# 	schedule_expression = "rate(1 minute)"
# }

# resource "aws_cloudwatch_event_target" "this" {
# 	arn  = var.lambda_arn
# 	rule = resource.aws_cloudwatch_event_rule.this.name
# }

# resource "aws_lambda_permission" "this" {
# 	action        = "lambda:InvokeFunction"
# 	function_name = var.lambda_arn
# 	principal     = "events.amazonaws.com"
# 	source_arn    = resource.aws_cloudwatch_event_rule.this.arn
# }

# ! Part 2 - Do the same as Part 1 but use AWS Terraform Modules.

