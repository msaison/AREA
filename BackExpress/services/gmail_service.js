const {google} = require("googleapis");
const nodemailer = require("nodemailer");
const { db } = require("../config/dbconfig");

const {auths, auth_controllers} = require("../config/authconfig");
const Sentry = require("@sentry/node");

const service_type = "GMAIL";

async function sendMail(user, auth, to, subject, text, html) {
    console.log("Sending mail user_id: ", user.id);

    const controller = auth_controllers[auth.type]; // TODO check if controller exists
    let file = eval(controller);

    await file.authorize(user, async function (oAuth2Client, credentials_json, token_info) {
        try {
            const transport = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    type: 'OAuth2',
                    user: token_info.email,
                    clientId: credentials_json.web.client_id,
                    clientSecret: credentials_json.web.client_secret,
                    refreshToken: user.auths.find(auth => auth.type === auths.GOOGLE).refresh_token,
                    accessToken: oAuth2Client.credentials.access_token
                },
            });

            const mailOptions = {
                from: `Area Gmail notify <${token_info.email}>`,
                to: to,
                subject: subject,
                text: text,
                html: html,
            };

            const result = await transport.sendMail(mailOptions);
            return result;
        } catch (error) {
            Sentry.captureException(error);
            console.log(error);
        }
    }) // TODO try catch on create
}


function create_reaction(reactions, user, auth, params) {
}

function create_action(action, user, auth, params) {
}

function delete_action() {}

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
        where: {id: reaction.auth_id}
    });

    sendMail(user, auth,
        params[0].to,
        action_params[0].subject,
        action_params[0].text,
        action_params[0].body,
    )
}

function set_webhook(router) {}

module.exports = {
    create_reaction,
    create_action,
    delete_action,
    set_webhook,
    doReaction
};