const {back_url} = require("../config/utlconfig");

const clientId = 'CLIENT ID';
const clientSecret = 'CLIENT SECRET';
const redirect_uri = back_url + '/yammer_callback';

module.exports = {
    clientId,
    clientSecret,
    redirect_uri
}