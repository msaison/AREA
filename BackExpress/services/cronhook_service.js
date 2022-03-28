const { db } = require("../config/dbconfig");

const { auths, auth_controllers } = require("../config/authconfig");
const axios = require("axios");
const { back_url: backUrl } = require("../config/utlconfig");
const method_actions = require("../methods/actions");
const {service_controllers} = require("../config/servicesconfig");
const Sentry = require("@sentry/node");

const service_type = "CRONHOOK";

function create_reaction() { }

async function create_action(db_action, user, auth, params) {
    const controller = auth_controllers[auth.type]; // TODO check if controller exists
    let file = eval(controller);

    await file.authorize(user, async function (api_key) {
        let deliveries_url = backUrl + `/cronhook_webhook/${db_action.id}`;

        let hooks_list = await axios.get(`https://api.cronhooks.io/schedules?skip=0&limit=100`, {
            headers: {
                Authorization: `Bearer ${api_key}`
            }
        })
        hooks_list = hooks_list.data.items;
        if (hooks_list) {
            for (let hook of hooks_list) {
                if (hook.url === deliveries_url) {
                    await axios.delete(`https://api.cronhooks.io/schedules/${hook.id}`, {
                        headers: {
                            Authorization: `Bearer ${api_key}`
                        }
                    })
                }
            }
        }

        let opts =  {
            title: db_action.id,
            description: db_action.id,
            url: deliveries_url,
            timezone: "europe/paris",
            method: "POST",
            contentType: "application/json; charset=utf-8",
            isRecurring: db_action.action_type !== 'run_at_time',
            sendCronhookObject: false,
            sendFailureAlert: false,
        }
        if (db_action.action_type === 'run_at_time')
            opts.runAt = params[0].time.replace(/\s/g, 'T');
        else
            opts.cronExpression = params[0].cron;

        await axios.post(`https://api.cronhooks.io/schedules`, opts,
        {
            headers: {
                Authorization: `Bearer ${api_key}`
            }
        })
    })
}

async function delete_action(action, user, auth, params) {
    const controller = auth_controllers["CRONHOOK"]; // TODO check if controller exists
    let file = eval(controller);

    await file.authorize(user, async function (api_key) {
        let deliveries_url = backUrl + `/cronhook_webhook/${action.id}`;

        let hooks_list = await axios.get(`https://api.cronhooks.io/schedules?skip=0&limit=100`, {
            headers: {
                Authorization: `Bearer ${api_key}`
            }
        })
        hooks_list = hooks_list.data.items;

        if (hooks_list) {
            for (let hook of hooks_list) {
                console.log(hook.url, deliveries_url)
                if (hook.url === deliveries_url) {
                    await axios.delete(`https://api.cronhooks.io/schedules/${hook.id}`, {
                        headers: {
                            Authorization: `Bearer ${api_key}`
                        }
                    })
                }
            }
        }
    })
}


async function doReaction() { }

function set_webhook(router) {
    router.post('/cronhook_webhook/:action_id', async (req, res) => {
        let action_id = req.params.action_id;
        let action;

        try {
            action = await db.action.findUnique({
                where: {id: Number(action_id)}
            });
        } catch (err) {
            Sentry.captureException(err);
            return res.status(500).json({ message: err.message });
        }

        let reaction = await db.reaction.findUnique({
            where: {id: action.reaction_id}
        });

        const controller = service_controllers[reaction.service_type];
        let file = eval(controller);

        let text, action_params;
        switch (action.action_type) {
            case 'on_cron':
                text = "Cron : " + action.params[0].cron + " Match as been reached";
                action_params = [{
                    body: text,
                    text: text,
                    subject: text,
                }];
                file.doReaction(reaction, action_params);
                break;
            case 'run_at_time':
                text = "Time : " + action.params[0].time + "as been reached";
                action_params = [{
                    body: text,
                    text: text,
                    subject: text,
                }];
                file.doReaction(reaction, action_params);
                break;
        }

        res.status(200).send();
    })
}

module.exports = {
    create_reaction,
    create_action,
    delete_action,
    set_webhook,
    doReaction
};