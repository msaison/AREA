const { auths, auth_controllers } = require("../config/authconfig");
const backUrl = require("../config/utlconfig").back_url
const { db } = require("../config/dbconfig");
const axios = require("axios");
const { authorize } = require("../auths/yammer_auth");
var FormData = require('form-data');
const Sentry = require("@sentry/node");

async function sendMessage(user, email, message_body) {
    authorize(user, async function (access_token, clientId, user_id) {
        var id;

        var config = {
            method: 'get',
            url: `https://www.yammer.com/api/v1/users/by_email.json?email=${email}`,
            headers: {
                'Authorization': `Bearer ${access_token}`
            }
        };

        await axios(config)
            .then(function (response) {
                id = response.data[0]['id']
            
            })
            .catch(function (error) {
                console.log(error);
                Sentry.captureException(error);
            });


        var data = new FormData();
        data.append('body', message_body);
        data.append('direct_to_user_ids', id);

        var config = {
            method: 'post',
            url: 'https://www.yammer.com/api/v1/messages.json',
            headers: {
                'Authorization': `Bearer ${access_token}`,
                ...data.getHeaders()
            },
            data: data
        };

        axios(config)
            .then(function (response) {
                console.log(JSON.stringify(response.data));
            })
            .catch(function (error) {
                console.log(error);
                Sentry.captureException(error);
            });

        console.log(`Send private message`)
    })
}


function create_reaction(reactions, user, auth, params) { }
async function create_action(action, user, auth, params) { }

function delete_action() { }

async function doReaction(reaction, action_params) {
    let params = reaction.params;

    let user = await db.user.findUnique({
        where: { id: reaction.user_id },
        include: {
            auths: true,
            actions: true,
            reactions: true,
        }
    })
    let auth = await db.auth.findUnique({
        where: { id: reaction.auth_id }
    });

    sendMessage(user, params[0].email, action_params[0].text)
}

function set_webhook(router) {}

module.exports = {
    create_reaction,
    create_action,
    delete_action,
    set_webhook,
    doReaction
};