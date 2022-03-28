const auths = require('../config/authconfig').auths
const { db } = require("../config/dbconfig");
const axios = require('axios');
const { clientId, clientSecret, redirect_uri, SCOPES} = require('../app_config/githubConfig');
const {isMobile} = require("../config/authconfig");

function getNewToken(user) {
    var authUrl = (`https://github.com/login/oauth/authorize?client_id=${clientId}&scope=${SCOPES}&state=${user.id}&redirect_uri=${redirect_uri}`);
    console.log('Authorize this app by visiting this url:', authUrl);

    return (authUrl);
}

function set_callback(router) {
    router.get('/github_callback', async (req, res) => {
        let user_id = req.query.state;
        let code = req.query.code;
        const body = {
            client_id: clientId,
            client_secret: clientSecret,
            code: code
        };
        const opts = {headers: {accept: 'application/json'}};

        await axios.post(`https://github.com/login/oauth/access_token`, body, opts).then(async res => {
            let data = {user_id: Number(user_id), type: auths.GITHUB, access_token: res.data['access_token']}

            if (res.data['refresh_token']) data.refresh_token = res.data['refresh_token']

            let previous_record = await db.auth.findFirst({
                where: {user_id: Number(user_id), type: auths.GITHUB}
            });

            await db.auth.update({
                where: {id: previous_record.id},
                data: data,
            })

        })


        if (isMobile(req)) {
            res.redirect('area://callback'); //TODO 2 version one for web and one for mobile
        } else {
            res.redirect('http://localhost:8081/params');
        }
    })
}

async function authorize(user, callback) {
    // Check if we have previously stored a token.
    var token;
    user.auths.forEach(function (auth) {
        if (auth.type === auths.GITHUB) {
            token = auth.refresh_token;
        }
    });

    if (!token) return getNewToken(user);

    // callback(oAuth2Client, credentials_json);
}

module.exports = {
    set_callback: set_callback,
    authorize: authorize
};