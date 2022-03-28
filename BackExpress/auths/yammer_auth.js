const auths = require('../config/authconfig').auths
const { db } = require("../config/dbconfig");

const axios = require('axios');

const { clientId, clientSecret, redirect_uri } = require('../app_config/yammerConfig');
const {isMobile} = require("../config/authconfig");

function getNewToken(user) {
    var authUrl = (`https://www.yammer.com/oauth2/authorize?client_id=${clientId}&response_type=code&redirect_uri=${redirect_uri}&state=${user.id}`);

    return (authUrl);
}

async function getToken(user_id) {
    let auth;
    let access_token;

    auth = await db.auth.findFirst({
        where: { user_id: Number(user_id), type: auths.YAMMER }
    });
    access_token = auth.access_token;
    
    return access_token;
}

function getFirstToken(code, user_id) {
    const opts = { headers: { 'Content-Type': 'application/json' } };
    const body = {
        'code': code,
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret
    }

    axios.post('https://www.yammer.com/oauth2/access_token', body, opts,).
        then(res => res.data).
        then(data => {
            let data_ = { user_id: Number(user_id), type: auths.YAMMER, access_token: data['access_token']['token'], username: String(data['access_token']['user_id']) };
            db.auth.findFirst({
                where: { user_id: Number(user_id), type: auths.YAMMER }
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
        });
}

function set_callback(router) {
    router.get('/yammer_callback', (req, res) => {

        if (req.query.code) getFirstToken(req.query.code, req.query.state)

        if (isMobile(req)) {
            res.redirect('area://callback'); //TODO 2 version one for web and one for mobile
        } else {
            res.redirect('http://localhost:8081/params');
        }
    })
}

async function authorize(user, callback) {
    var token;
    let access_token;;
    let user_id;
    user.auths.forEach(function (auth) {
        if (auth.type === auths.YAMMER) {
            token = auth.access_token;
            user_id = Number(auth.username);
        }
    });

    if (!token) return getNewToken(user);
    
    access_token = await getToken(user.id)

    callback(access_token, clientId, user_id);
}

module.exports = {
    set_callback: set_callback,
    authorize: authorize
};