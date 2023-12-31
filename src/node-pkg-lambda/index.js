const fetch = require('node-fetch')
const { faker } = require('@faker-js/faker')

// * To create a custom runtime for AWS, lambda, we fetch our event from and return our payload to
// * the base url that they provide us. https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html
const BASE_URL = `http://${process.env.AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation`

const main = async (handler) => {
	while (true) {
		// * Fetch event from AWS
		const eventResponse = await fetch(`${BASE_URL}/next`)
		if (!eventResponse.ok) {
			throw new Error(`Unexpected response when invoking: ${eventResponse.status} ${eventResponse.statusText}`)
		}

		// * Fetch Lambda context from environment and invoke request.
		const deadlineMs = eventResponse.headers.get('Lambda-Runtime-Deadline-Ms')
		const context = {
			functionName:    process.env.AWS_LAMBDA_FUNCTION_NAME,
			functionVersion: process.env.AWS_LAMBDA_FUNCTION_VERSION,
			logGroupName:    process.env.AWS_LAMBDA_LOG_GROUP_NAME,
			logStreamName:   process.env.AWS_LAMBDA_LOG_STREAM_NAME,
			memoryLimitInMb: process.env.AWS_LAMBDA_FUNCTION_MEMORY_SIZE,

			awsRequestId:       eventResponse.headers.get('Lambda-Runtime-Aws-Request-Id'),
			clientContext:      eventResponse.headers.get('Lambda-Runtime-Client-Context'),
			identity:           eventResponse.headers.get('Lambda-Runtime-Cognito-Identity'),
			invokedFunctionArn: eventResponse.headers.get('Lambda-Runtime-Invoked-Function-Arn'),

			deadlineMs,
			getRemainingTimeInMillis: () => deadlineMs - new Date().getTime(),
		}

		// * Get event as JSON from response
		const event = await eventResponse.json()

		// * Generate our results
		const result = await handler(event, context)

		// * Return our results to any request waiting for our results (i.e. invocationType: "RequestResponse")
		const requestResponse = await fetch(`${BASE_URL}/${context.awsRequestId}/response`, {
			body: JSON.stringify({ result }),
			method: 'POST',
		})
		if (requestResponse.status !== 202) {
			throw new Error(`Unexpected response when responding: ${requestResponse.status} ${requestResponse.statusText}`)
		}
	}
}

const handler = async (cloudevent = {}, ctx = {}) => {
	console.log('Time remaining: ', ctx.getRemainingTimeInMillis())

	console.log(ctx)

	console.log('Time remaining: ', ctx.getRemainingTimeInMillis())

	const profile = {
		firstName: faker.person.firstName(),
		lastName: faker.person.lastName(),
		phoneNumber: faker.phone.number(),
		vehicleType: faker.vehicle.model(),
	}

	console.log('Time remaining: ', ctx.getRemainingTimeInMillis())

	return {
		body: JSON.stringify({ profile }),
		headers: { 'Content-Type': 'application/json' },
		statusCode: 200,
	}
};

main(handler)
