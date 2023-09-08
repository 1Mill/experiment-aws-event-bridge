terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.12"
		}
	}
}

provider "aws" {
	region = "ca-central-1"

	default_tags {
		tags = {
			environment          = "prod"
			pii                  = false
			terragrunt_base_path = "1Mill/experiment-aws-event-bridge"
		}
	}
}

module "event_bridge" {
	source = "./src/event-bridge"

	lambda_arn = module.node-lambda.arn
}

module "crystal-lambda" { source = "./src/crystal-lambda" }
module "node-lambda" { source = "./src/node-lambda" }
