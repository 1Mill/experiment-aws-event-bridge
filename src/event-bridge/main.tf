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

resource "aws_lambda_permission" "this" {
	action        = "lambda:InvokeFunction"
	function_name = var.lambda_arn
	principal     = "events.amazonaws.com"
	source_arn    = resource.aws_cloudwatch_event_rule.this.arn
}
