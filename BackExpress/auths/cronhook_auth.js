const { api_key } = require('../app_config/cronhookConfig');

function set_callback(router) {
}

async function authorize(user, callback) {
    callback(api_key);
}

module.exports = {
    set_callback: set_callback,
    authorize: authorize
};
