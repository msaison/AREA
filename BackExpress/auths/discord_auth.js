const auths = require('../config/authconfig').auths
const { db } = require("../config/dbconfig");
const axios = require('axios');
var qs = require('qs');

const { client_secret, client_id, redirect_uri, SCOPES } = require('../app_config/discordConfig');
const {isMobile} = require("../config/authconfig");
const Sentry = require("@sentry/node");

function getNewToken(user) {
    var authUrl = (`https://discord.com/api/oauth2/authorize?client_id=${client_id}&redirect_uri=${redirect_uri}&response_type=code&scope=${SCOPES}&state=${user.id}`);
    console.log('Authorize this app by visiting this url:', authUrl);

    return (authUrl);
}

function getFirstToken(code, user_id) {
    var data = qs.stringify({
        'client_id': client_id,
        'client_secret': client_secret,
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirect_uri,
    });
    var config = {
        method: 'post',
        url: 'https://discord.com/api/oauth2/token',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: data
    };

    axios(config)
        .then(function (response) {
            let data_ = {
                user_id: Number(user_id),
                type: auths.DISCORD,
                refresh_token: response.data['refresh_token'],
                access_token: response.data['access_token'],
                password: response.data['webhook']['channel_id']
            };
            db.auth.findFirst({
                where: { user_id: Number(user_id), type: auths.DISCORD }
            }).then(res => res['id']).
                then(id => {
                    db.auth.update({
                        where: { id: Number(id) },
                        data: data_,
                    }).then(res => {
                        if (!res.ok) {
                        }
                    })
                });
        })
        .catch(function (error) {
            Sentry.captureException(e);
            console.log(error);
        });
}

async function getChannelId(user_id) {
    let auth;
    let channel_id;

    auth = await db.auth.findFirst({
        where: { user_id: Number(user_id), type: auths.DISCORD }
    });
    channel_id = auth.password;
    
    return channel_id;
}

function set_callback(router) {
    router.get('/discord_callback', (req, res) => {

        if (req.query.code) getFirstToken(req.query.code, req.query.state)

        if (isMobile(req)) {
            res.redirect('area://callback'); //TODO 2 version one for web and one for mobile
        } else {
            res.redirect('http://localhost:8081/params');
        }
    })
}

async function authorize(user, callback) {
    // Check if we have previously stored a token.
    var token
    let channel_id
    user.auths.forEach(function (auth) {
        if (auth.type === auths.DISCORD) {
            token = auth.refresh_token;
        }
    });

    if (!token) return getNewToken(user);

    channel_id = await getChannelId(user.id)

    callback(channel_id);
}

module.exports = {
    set_callback: set_callback,
    authorize: authorize
};
