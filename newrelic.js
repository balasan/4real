/**
 * New Relic agent configuration.
 *
 * See lib/config.defaults.js in the agent distribution for a more complete
 * description of configuration variables and their potential values.
 */
exports.config = {
	/**
	 * Array of application names.
	 */
	app_name: ['4REAL'],
	/**
	 * Your New Relic license key.
	 */
	license_key: '40f9cf634f41bb3d9ed9f98b04684df6c06b0995',
	logging: {
		/**
		 * Level at which to log. 'trace' is most useful to New Relic when diagnosing
		 * issues with the agent, 'info' and higher will impose the least overhead on
		 * production applications.
		 */
		level: 'trace'
	}
};