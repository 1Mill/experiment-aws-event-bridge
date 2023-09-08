require "crambda"
require "faker"
require "json"

def handler(cloudevent : JSON::Any, context : Crambda::Context)
	profile = {
		firstName: Faker::Name.first_name,
		lastName: Faker::Name.last_name,
		phoneNumber: Faker::PhoneNumber.phone_number,
		vehicleType: Faker::Commerce.product_name,
	}

	{
		body: { profile }.to_json,
		headers: { 'Content-Type': 'application/json' },
		statusCode: 200,
	}
end

Crambda.run_handler(->handler(JSON::Any, Crambda::Context))
