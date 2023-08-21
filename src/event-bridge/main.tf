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
# module "eventbridge" {
# 	source  = "terraform-aws-modules/eventbridge/aws"
# 	version = "~> 2.3.0"

# 	create_bus = false

# 	rules = {
# 		crons = { schedule_expression = "rate(1234 minutes)" }
# 		something = {
# 			event_pattern = jsonencode({
# 				source = ["myapp.something"]
# 			})
# 		}
# 	}

# 	targets = {
# 		crons = [
# 			{
# 				arn  = var.lambda_arn
# 				name = "profile-generator-lambda-event-rule"
# 			}
# 		]
# 		something = [
# 			{
# 				arn  = var.lambda_arn
# 				name = "something-rule"
# 			}
# 		]
# 	}
# }

# resource "aws_lambda_permission" "crons" {
# 	action        = "lambda:InvokeFunction"
# 	function_name = var.lambda_arn
# 	principal     = "events.amazonaws.com"
# 	source_arn    = module.eventbridge.eventbridge_rule_arns["crons"]
# }

# resource "aws_lambda_permission" "something" {
# 	action        = "lambda:InvokeFunction"
# 	function_name = var.lambda_arn
# 	principal     = "events.amazonaws.com"
# 	source_arn    = module.eventbridge.eventbridge_rule_arns["something"]
# }

# ! Part 3 - Do the same as Part 1 but use Cloud Posse module
# module "cloudwatch_event" {
# 	source  = "cloudposse/cloudwatch-events/aws"
#   	version = "~> 0.6.1"

# 	name          = "somename"

# 	cloudwatch_event_rule_pattern = { source = ["myapp.something"] }
# 	cloudwatch_event_target_arn   = var.lambda_arn
# }

# resource "aws_lambda_permission" "this" {
# 	action        = "lambda:InvokeFunction"
# 	function_name = var.lambda_arn
# 	principal     = "events.amazonaws.com"
# 	source_arn    = module.cloudwatch_event.aws_cloudwatch_event_rule_arn
# }

# ! Part 4 - Do the same as Part 1 but with in-house module
module "invoke_lambda_by_pattern" {
	source = "./modules/eventbridge-invoke-lambda-rule"

	lambda = { arn = var.lambda_arn }
	rule   = { event_pattern = jsonencode({ source = ["myapp.testing-something-new"] }) }
}

module "invoke_lambda_by_schedule" {
	source = "./modules/eventbridge-invoke-lambda-rule"

	lambda = { arn = var.lambda_arn }
	rule   = { schedule_expression = "rate(1234 minutes)" }
}

module "invoke_lambda_by_details" {
	source = "./modules/eventbridge-invoke-lambda-rule"

	lambda = { arn = var.lambda_arn }
	rule   = { event_pattern = jsonencode({
		detail = {
			state = ["some-placeholder-state"]
		}
	}) }
}

module "invoke_lambda_by_cloudevent" {
	source = "./modules/eventbridge-invoke-lambda-rule"

	lambda = { arn = var.lambda_arn }
	rule   = { event_pattern = jsonencode({
		detail = {
			type = ["cmd.placeholder.v0"]
		}
	}) }
}
