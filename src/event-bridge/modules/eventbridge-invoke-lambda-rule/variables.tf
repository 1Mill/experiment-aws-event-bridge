variable "lambda" {
	type = object({
	  arn = string
	})
}

variable "rule" {
	type = object({
		description         = optional(string)
		event_pattern       = optional(string)
		name                = string
		schedule_expression = optional(string)
	})
}
