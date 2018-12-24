'use latest'

require('isomorphic-fetch')

module.exports = event => {
	
	const endpoint = `http://api.open-notify.org/iss-now.json`
	
	return fetch(endpoint)
		.then(response => response.json())
		.then(data => {
			if (data.message == 'success') {
				return {
					data: {
						longitude: data.iss_position.longitude,
						latitude: data.iss_position.latitude,
						timestamp: data.timestamp
					}
				}
			}
			else {
				return {error: data}
			}
		})
}