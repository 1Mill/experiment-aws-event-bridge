variable "lambda" {
	type = object({
	  arn = string
	})
}

variable "rule" {
	type = object({
		event_pattern       = optional(string)
		schedule_expression = optional(string)
	})
}
