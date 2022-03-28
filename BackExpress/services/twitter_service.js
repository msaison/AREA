const { db } = require("../config/dbconfig");
const { authorize } = require("../auths/twitter_auth");
const Twitter = require('twitter');
const {TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET} = require('../app_config/twitterConfig');

async function postToApi(user, route, queryparam) {
    authorize(user, async function (oauth_tokens) {
        const client = new Twitter({
            consumer_key: TWITTER_CONSUMER_KEY,
            consumer_secret: TWITTER_CONSUMER_SECRET,
            access_token_key: oauth_tokens.oauth_token,
            access_token_secret: oauth_tokens.oauth_token_secret,
        });
        try {
            client.post(route, queryparam)
        } catch (err) {
            console.log(err);
        }
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

    switch (reaction.reaction_type) {
        case 'post_tweet':
            await postToApi(user, '/statuses/update', { 'status': action_params[0].text });
            break;
        case 'change_desc':
            await postToApi(user, '/account/update_profile', { 'description': action_params[0].text })
            break;
    }
}

function set_webhook(router) { }

module.exports = {
    create_reaction,
    create_action,
    delete_action,
    set_webhook,
    doReaction
};