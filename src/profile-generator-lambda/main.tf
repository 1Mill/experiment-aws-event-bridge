module "lambda" {
	version = "~> 2.1"
  	source  = "1Mill/serverless-docker-function/aws"

	docker      = { build = abspath(path.module) }
	environment = { NODE_ENV = "production" }
	function    = { name = "profile-generator-lambda" }
}
