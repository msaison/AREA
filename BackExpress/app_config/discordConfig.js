const {back_url} = require("../config/utlconfig");

const client_secret = 'CLIENT SECRET';
const client_id = 'CLIENT ID';

const redirect_uri = back_url + '/discord_callback'
const SCOPES =
    "identify%20email%20rpc.notifications.read%20connections%20guilds.members.read%20webhook.incoming%20messages.read%20bot&permissions=8"

module.exports = {
    client_secret,
    client_id,
    redirect_uri,
    SCOPES
}