const {back_url} = require("../config/utlconfig");

const clientId = 'CLIENT ID';
const clientSecret = 'CLIENT SECRET';
const redirect_uri = back_url + '/github_callback';

const SCOPES = [
    "repo",
    "user",
    "repo_deployment",
];

module.exports = {
    clientId,
    clientSecret,
    redirect_uri,
    SCOPES
}