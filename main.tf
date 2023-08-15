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
			terragrunt_base_path = "1Mill/experimental-aws-event-bridge"
		}
	}
}
