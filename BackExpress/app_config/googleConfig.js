const back_url = require('../config/utlconfig').back_url

const SCOPES = [
    "https://mail.google.com/",
    "https://www.googleapis.com/auth/gmail.addons.current.action.compose",
    "https://www.googleapis.com/auth/gmail.addons.current.message.action",
    "https://www.googleapis.com/auth/gmail.addons.current.message.metadata",
    "https://www.googleapis.com/auth/gmail.addons.current.message.readonly",
    "https://www.googleapis.com/auth/gmail.compose",
    "https://www.googleapis.com/auth/gmail.insert",
    "https://www.googleapis.com/auth/gmail.labels",
    "https://www.googleapis.com/auth/gmail.metadata",
    "https://www.googleapis.com/auth/gmail.modify",
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/gmail.send",
    "https://www.googleapis.com/auth/gmail.settings.basic",
    "https://www.googleapis.com/auth/gmail.settings.sharing",
    "https://www.googleapis.com/auth/userinfo.email",
];
const credentials_json = {"web":{"client_id":"CLIENT ID","project_id":"PROJECT ID","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"CLIENT SECRET","redirect_uris":["REDIRECT URIS"],"javascript_origins":[""]}}

const redirect_url = back_url + '/google_callback'

module.exports = {
    SCOPES,
    redirect_url,
    credentials_json
}