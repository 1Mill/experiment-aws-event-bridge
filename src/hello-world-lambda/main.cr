require "json"
require "crambda"

def handler(cloudevent : JSON::Any, context : Crambda::Context)
	pp "---"
	pp "Hello world!"
	pp cloudevent
	pp context
	pp "---"

	true
end

Crambda.run_handler(->handler(JSON::Any, Crambda::Context))
