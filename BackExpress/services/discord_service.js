const { auths, auth_controllers } = require("../config/authconfig");
const backUrl = require("../config/utlconfig").back_url
const {service_controllers} = require("../config/servicesconfig");
const { db } = require("../config/dbconfig");
const axios = require("axios");
const { authorize } = require("../auths/discord_auth");
const botToken = 'OTQ5NDg4NTM5MTMxODU4OTQ0.YiLGHA.bo9Wx_9FpimE3uS0DL2QQuIrG1g';

const Discord = require('discord.js');
const Sentry = require("@sentry/node");
const client_bot = new Discord.Client();

function create_reaction(reactions, user, auth, params) { }

async function create_action(action, user, auth, params) {
    let actions = await db.action.findMany({ where: {action_type: 'new_message_on_channel' } } )

    let reaction;
    actions.forEach(async (action) => {
        reaction = await db.reaction.findUnique({
            where: { id: action.reaction_id }
        });

        user = await db.user.findUnique({
            where: { id: action.user_id },
            include: {
                auths: true,
                actions: true,
                reactions: true,
            }
        })
        getMessageBot(user, reaction)
    })
}

client_bot.login(botToken);

function delete_action() { }

async function getMessageBot(user, reaction) {
    await authorize(user, async function (channel_id) {
        try {
            client_bot.on('message', async message  => {
                let exist = await db.reaction.findUnique({where : {id: reaction.id}})
                if (!exist) {
                    return
                }

                const controller = service_controllers[reaction.service_type];
                let file = eval(controller);
                let text = 'New message posted on discord by: ' + message.author.username + '.\nOn channel: ' + message.channel.name + '\n' + 'Posted at: ' + message.createdAt + '\nContent: ' + message.content;
                let action_params = [{
                    body: text,
                    text: text,
                    subject: text,
                }];
                file.doReaction(reaction, action_params);
            });
        } catch (err) {
            Sentry.captureException(err);
            console.log(err);
        }
    })
}

async function setupBot(user, text) {
    await authorize(user, async function (channel_id) {
        try {
            client_bot.channels.cache.get(channel_id).send(text + '@everyone');
        } catch (err) {
            Sentry.captureException(err);
            console.log(err);
        }
    })
}

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

    setupBot(user, action_params[0].text)
}

async function set_webhook(router) {
    users = await db.user.findMany({
        where: { },
        include: {
            auths: true,
            actions: true,
            reactions: true,
        }
    })
    users.forEach(async (user) => {
        let actions = await db.action.findMany({where: {
            user_id: user.id,
            action_type: 'new_message_on_channel'
        }})
        actions.forEach(async (action) => {
            let reaction = await db.reaction.findUnique({where: {
                id: action.reaction_id
            }})
            getMessageBot(user, reaction)
        })
    })
}

module.exports = {
    create_reaction,
    create_action,
    delete_action,
    set_webhook,
    doReaction
};