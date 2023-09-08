module "lambda" {
	source  = "1Mill/serverless-docker-function/aws"
	version = "~> 3.1"

	docker      = { build = abspath(path.module) }
	environment = { NODE_ENV = "production" }
	function    = {
		name    = "hello-world-lambda"
		# version = "some-static-value-to-avoid-docker-rebuilds"
	}
}

module "rule" {
	source  = "1Mill/eventbridge-invoke-lambda/aws"
	version = "~> 0.0.1"

	details = { type = ["cmd.placeholder.v0"] }
	lambda  = { arn = module.lambda.arn }
}
