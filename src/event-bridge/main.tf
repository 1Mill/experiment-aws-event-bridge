variable "lambda_arn" { type = string }

resource "aws_cloudwatch_event_rule" "this" {
	description         = "retry scheuled every 1 minute"
	name                = "profile-generator-lambda-event-rule"
	schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "this" {
	arn  = var.lambda_arn
	rule = resource.aws_cloudwatch_event_rule.this.name
}
