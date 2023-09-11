const fetch = require('node-fetch')

const main = async () => {
	console.log('hello world')

	while (true) {
		const invokeResponse = await fetch(`http://${process.env.AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next`)
		if (!invokeResponse.ok) {
			throw new Error(`Unexpected response when invoking: ${invokeResponse.status} ${invokeResponse.statusText}`)
		}

		const event = await invokeResponse.json()
		console.log({ event })

		const result = 'aaaaa'

		const awsRequestId = invokeResponse.headers.get('Lambda-Runtime-Aws-Request-Id')
		const returnResponse = await fetch(`http://${process.env.AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/${awsRequestId}/response`, {
			body: JSON.stringify({ event, result }),
			method: 'POST',
		})
		if (returnResponse.status !== 202) {
			throw new Error(`Unexpected response when responding: ${returnResponse.status} ${returnResponse.statusText}`)
		}
	}
}

main()

// const { faker } = require('@faker-js/faker');

// exports.handler = async (cloudevent = {}, ctx = {}) => {
// 	console.log('starting')

// 	const profile = {
// 		firstName: faker.person.firstName(),
// 		lastName: faker.person.lastName(),
// 		phoneNumber: faker.phone.number(),
// 		vehicleType: faker.vehicle.model(),
// 	}

// 	console.log('profile generated')

// 	return {
// 		body: JSON.stringify({ profile }),
// 		headers: { 'Content-Type': 'application/json' },
// 		statusCode: 200,
// 	}
// };
