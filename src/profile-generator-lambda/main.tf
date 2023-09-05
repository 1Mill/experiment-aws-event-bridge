module "lambda" {
	source  = "1Mill/serverless-docker-function/aws"
	version = "~> 3.0"

	docker      = { build = abspath(path.module) }
	environment = { NODE_ENV = "production" }
	function    = {
		name    = "profile-generator-lambda"
		version = "some-static-value-to-avoid-docker-rebuilds"
	}
}

output "arn" { value = module.lambda.lambda.lambda_function_arn }
