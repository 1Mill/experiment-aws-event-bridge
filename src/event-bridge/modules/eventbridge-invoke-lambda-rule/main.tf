resource "aws_cloudwatch_event_rule" "this" {
	event_pattern       = var.rule.event_pattern
	name_prefix         = "eventbridge-invoke-lambda-rule-"
	schedule_expression = var.rule.schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
	arn  = var.lambda.arn
	rule = resource.aws_cloudwatch_event_rule.this.name
}

resource "aws_lambda_permission" "this" {
	action        = "lambda:InvokeFunction"
	function_name = var.lambda.arn
	principal     = "events.amazonaws.com"
	source_arn    = resource.aws_cloudwatch_event_rule.this.arn
}
