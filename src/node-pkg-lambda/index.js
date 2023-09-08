const { faker } = require('@faker-js/faker');

exports.handler = async (cloudevent = {}, ctx = {}) => {
	console.log('starting')

	const profile = {
		firstName: faker.person.firstName(),
		lastName: faker.person.lastName(),
		phoneNumber: faker.phone.number(),
		vehicleType: faker.vehicle.model(),
	}

	console.log('profile generated')

	return {
		body: JSON.stringify({ profile }),
		headers: { 'Content-Type': 'application/json' },
		statusCode: 200,
	}
};
