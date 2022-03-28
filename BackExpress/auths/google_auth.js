const auths = require('../config/authconfig').auths
const isMobile = require('../config/authconfig').isMobile
const {db} = require("../config/dbconfig");
const backUrl = require('../config/utlconfig').back_url

const {google} = require('googleapis');
const nodemailer = require('nodemailer');
const { redirect_url, credentials_json, SCOPES } = require('../app_config/googleConfig');

// Load client secrets from a local file.
// let credentials_json;
// fs.readFile(__dirname + '/client_secret_1053210592062.json', (err, content) => {
//     if (err) return console.log('Error loading client secret file:', err);
//     // Authorize a client with credentials, then call the Gmail API.
//     // authorize(JSON.parse(content), listLabels);
//     console.log("credentials_json: ", JSON.parse(content));
//     credentials_json = JSON.parse(content);
// });

// /**
//  * Lists the labels in the user's account.
//  *
//  * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
//  */
// function listLabels(auth) {
//     const gmail = google.gmail({version: 'v1', auth});
//     gmail.users.labels.list({
//         userId: 'me',
//     }, (err, res) => {
//         if (err) return console.log('The API returned an error: ' + err);
//         const labels = res.data.labels;
//         if (labels.length) {
//             console.log('Labels:');
//             labels.forEach((label) => {
//                 console.log(`- ${label.name}`);
//             });
//         } else {
//             console.log('No labels found.');
//         }
//     });
// }

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 * @param {google.auth.OAuth2} oAuth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback for the authorized client.
 */
function getNewToken(oAuth2Client, user) {
    var authUrl = oAuth2Client.generateAuthUrl({
        redirect_uri: redirect_url,
        state: user.id,
        access_type: 'offline',
        scope: SCOPES,
    });
    console.log('Authorize this app by visiting this url:', redirect_url);

    return (authUrl);
}

function set_callback(router) {

    // method: GET
    // code is oauth2 code
    // state is user id
    router.get('/google_callback', (req, res) => {
        let code = req.query.code
        let user_id = req.query.state

        const {client_secret, client_id, redirect_uris} = credentials_json.web;
        const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, backUrl + '/google_callback');

        oAuth2Client.getToken(code, async (err, token) => {
            if (err) return console.error('Error retrieving access token', err);

            oAuth2Client.setCredentials(token);

            let data = {user_id: Number(user_id), type: auths.GOOGLE, access_token: token.access_token}

            if (token.refresh_token) data.refresh_token = token.refresh_token

            let previous_record = await db.auth.findFirst({
                where: {user_id: Number(user_id), type: auths.GOOGLE}
            });

            await db.auth.update({
                where: {id: previous_record.id},
                data: data,
            })
        });

        if (isMobile(req)) {
            res.redirect('area://callback'); //TODO 2 version one for web and one for mobile
        } else {
            res.redirect('http://localhost:8081/params');
        }
    })
}

async function authorize(user, callback) {
    const {client_secret, client_id, redirect_uris} = credentials_json.web;
    const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);

    // Check if we have previously stored a token.
    var token;
    user.auths.forEach(function (auth) {
        if (auth.type === auths.GOOGLE) {
            token = auth.refresh_token;
        }
    });

    if (!token) return getNewToken(oAuth2Client, user);
    oAuth2Client.setCredentials({refresh_token: token});
    try {
        await oAuth2Client.getAccessToken();
    } catch (e) {
        console.log("Refresh token is no more valid: ", e);
        let previous_record = await db.auth.findFirst({
            where: {user_id: Number(user.id), type: auths.GOOGLE}
        });
        await db.auth.update({
            data: {refresh_token: null},
            where: {id: previous_record.id}
        });
        return;
    }
    let token_info = await oAuth2Client.getTokenInfo(
        oAuth2Client.credentials.access_token
    );
    await callback(oAuth2Client, credentials_json, token_info);
}

module.exports = {
    set_callback: set_callback,
    authorize: authorize
};