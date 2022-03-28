const auths = require('../config/authconfig').auths
const { db } = require("../config/dbconfig");

const axios = require('axios');
const Oauth1Helper = require('../methods/helper_oauth1')
const {isMobile} = require("../config/authconfig");
let user_id

function parseQuery(queryString) {
    var query = {};
    var pairs = (queryString[0] === '?' ? queryString.substr(1) : queryString).split('&');
    for (var i = 0; i < pairs.length; i++) {
        var pair = pairs[i].split('=');
        query[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1] || '');
    }
    return query;
}

async function getNewToken(user) {
    const request = {
        url: 'https://api.twitter.com/oauth/request_token',
        method: 'POST',
        body: {
            "user_id": user.id
        }
    };
    const authHeader = Oauth1Helper.getAuthHeaderForRequest(request)
    let response = await axios.post(
        request.url,
        request.body,
        { headers: authHeader }).catch(function (error) {
            if (error.response) {
                console.log(error.response.data);
                console.log(error.response.status);
                console.log(error.response.headers);
            }
        });
    authUrl = `https://api.twitter.com/oauth/authorize?oauth_token=${parseQuery(response.data).oauth_token}`;
    return (authUrl);
}

async function getToken(unique_usr) {
    let auth;
    let tokens;

    auth = await db.auth.findFirst({
        where: { user_id: Number(unique_usr), type: auths.TWITTER }
    });

    tokens = {
        oauth_token: auth.access_token,
        oauth_token_secret: auth.refresh_token,
        oauth_user_id: auth.username,
    }
    return tokens;
}

async function getFirstToken(oauth_verifier, oauth_token) {
    let response = await axios.post(`https://api.twitter.com/oauth/access_token?oauth_verifier=${oauth_verifier}&oauth_token=${oauth_token}`)
    let res = parseQuery(response.data);
    let data = { refresh_token: res.oauth_token_secret, access_token: res.oauth_token, username: res.user_id }
    let previous_record = await db.auth.findFirst({
        where: { user_id: Number(user_id), type: auths.TWITTER }
    });

    await db.auth.update({
        where: { id: previous_record.id },
        data: data,
    })
}

function set_callback(router) {
    router.get('/twitter_callback', (req, res) => {

        if (req.query.oauth_verifier && req.query.oauth_token) getFirstToken(req.query.oauth_verifier, req.query.oauth_token)

        if (isMobile(req)) {
            res.redirect('area://callback'); //TODO 2 version one for web and one for mobile
        } else {
            res.redirect('http://localhost:8081/params');
        }
    })
}

async function authorize(user, callback) {
    user_id = user.id;
    var token;
    let oauth_tokens;
    user.auths.forEach(function (auth) {
        if (auth.type === auths.TWITTER) {
            token = auth.refresh_token;
        }
    });

    if (!token) return await getNewToken(user);

    oauth_tokens = await getToken(user.id);

    callback(oauth_tokens);
}

module.exports = {
    set_callback: set_callback,
    authorize: authorize
};