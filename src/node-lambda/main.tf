module "lambda" {
	source  = "1Mill/serverless-docker-function/aws"
	version = "~> 3.1"

	docker      = { build = abspath(path.module) }
	environment = { NODE_ENV = "production" }
	function    = {
		name    = "node-lambda"
		version = "some-static-value-to-avoid-docker-rebuilds"
	}
}

locals { arn = module.lambda.lambda.lambda_function_arn }

output "arn" { value = local.arn }

# ! Part 5 - Move Part 4 to responsibility of Lambda
# module "invoke_lambda_by_pattern" {
# 	source = "../event-bridge/modules/eventbridge-invoke-lambda-rule"

# 	lambda = { arn = local.arn }
# 	rule   = { event_pattern = jsonencode({ source = ["myapp.testing-something-new"] }) }
# }

# module "invoke_lambda_by_schedule" {
# 	source = "../event-bridge/modules/eventbridge-invoke-lambda-rule"

# 	lambda = { arn = local.arn }
# 	rule   = { schedule_expression = "rate(1234 minutes)" }
# }

# module "invoke_lambda_by_details" {
# 	source = "../event-bridge/modules/eventbridge-invoke-lambda-rule"

# 	lambda = { arn = local.arn }
# 	rule   = { event_pattern = jsonencode({
# 		detail = {
# 			state = ["some-placeholder-state"]
# 		}
# 	}) }
# }

# module "invoke_lambda_by_cloudevent" {
# 	source = "../event-bridge/modules/eventbridge-invoke-lambda-rule"

# 	lambda = { arn = local.arn }
# 	rule   = { event_pattern = jsonencode({
# 		detail = {
# 			type = ["cmd.placeholder.v0"]
# 		}
# 	}) }
# }

# module "invoke_lambda_by_cloudevent_wschannelid" {
# 	source = "../event-bridge/modules/eventbridge-invoke-lambda-rule"

# 	lambda = { arn = local.arn }
# 	rule   = { event_pattern = jsonencode({
# 		detail = {
# 			wschannelid = [ { exists = true  } ]
# 		}
# 	}) }
# }

# ! Part 6 - Use external module to build rule for default event bridge.
module "rule" {
	source  = "1Mill/eventbridge-invoke-lambda/aws"
	version = "~> 0.0.1"

	details = { type = ["cmd.placeholder.v0"] }
	lambda  = { arn = module.lambda.arn }
}
