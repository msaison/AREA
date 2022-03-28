const {auths, auth_controllers} = require("../config/authconfig");
const backUrl = require("../config/utlconfig").back_url
const {db} = require("../config/dbconfig");
const axios = require("axios");
const method_actions = require("../methods/actions");
const {service_controllers} = require("../config/servicesconfig");
const Sentry = require("@sentry/node");

const service_type = "GITHUB";

function create_reaction(reactions, user, auth, params) {

}

async function create_action(action, user, auth, params) {
    let previous_record = await db.auth.findFirst({
        where: {user_id: Number(user.id), type: auths.GITHUB}
    });

    let owner = await axios.get('https://api.github.com/user', {
        headers: {
            Authorization: `token ${previous_record.access_token}`
        }
    })
    owner = owner.data.login;

    let deliveries_url = backUrl + `/github_webhook/${action.id}`;

    let hooks_list = await axios.get(`https://api.github.com/repos/${owner}/${params[0].repo}/hooks`, {
        headers: {
            Authorization: `token ${previous_record.access_token}`
        }
    })
    hooks_list = hooks_list.data;

    for (let hook of hooks_list) {
        if (hook.config.url === deliveries_url) {
            await axios.delete(`https://api.github.com/repos/${owner}/${params[0].repo}/hooks/${hook.id}`, {
                headers: {
                    Authorization: `token ${previous_record.access_token}`
                }
            })
        }
    }

    let event = method_actions.get_service_config(action.service_type).actions.filter(function (action_conf) {
        return action_conf.type === action.action_type;
    })[0].event;
    await axios.post(`https://api.github.com/repos/${owner}/${params[0].repo}/hooks`, {
        accept: 'application/vnd.github.v3+json',
        config: {
            url: deliveries_url,
            content_type: 'json',
            insecure_ssl: '1',
        },
        events: [event],
        name: 'web',
    },
    {
        headers: {
            Authorization: `token ${previous_record.access_token}`
        }
    })
}

async function delete_action(action, user, auth, params) {
    let previous_record = await db.auth.findFirst({
        where: {user_id: Number(user.id), type: auths.GITHUB}
    });

    let owner = await axios.get('https://api.github.com/user', {
        headers: {
            Authorization: `token ${previous_record.access_token}`
        }
    })
    owner = owner.data.login;


    let deliveries_url = backUrl + `/github_webhook/${action.id}`;

    let hooks_list = await axios.get(`https://api.github.com/repos/${owner}/${params[0].repo}/hooks`, {
        headers: {
            Authorization: `token ${previous_record.access_token}`
        }
    })
    hooks_list = hooks_list.data;

    for (let hook of hooks_list) {
        if (hook.config.url === deliveries_url) {
            await axios.delete(`https://api.github.com/repos/${owner}/${params[0].repo}/hooks/${hook.id}`, {
                headers: {
                    Authorization: `token ${previous_record.access_token}`
                }
            })
        }
    }
}

function set_webhook(router) {
    router.post('/github_webhook/:action_id', async (req, res) => {
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

        let event = method_actions.get_service_config(action.service_type).actions.filter(function (action_conf) {
            return action_conf.type === action.action_type;
        })[0].event;

        switch (event) {
            case 'push':
                if (action.action_type === 'new_commit' && req.body.commits && req.body.head_commit) {
                    if (action.params[0].branch && action.params[0].branch.length !== 0 && !req.body.ref.includes(action.params[0].branch))
                        return res.status(200).send();

                    let text = 'New commit on ' + req.body.ref + '\n' +
                        'Author: ' + req.body.sender.login + '\n' + 'Message: ' + req.body.head_commit.message + '\n' + req.body.head_commit.url;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
                break;
            case 'issues':
                if (action.action_type === 'new_issue' && req.body.issue && req.body.action === 'opened') {
                    let text = 'New issue on ' + req.body.repository.full_name + '\n' + req.body.issue.title + '\n' + req.body.issue.url;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
                if (action.action_type === 'closed_issue' && req.body.issue && req.body.action === 'closed') {
                    let text = 'An issues as been closed on ' + req.body.repository.full_name + '\n' + req.body.issue.title + '\n' + req.body.issue.url;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
                if (action.action_type === 'on_issue_edit' && req.body.issue && req.body.issue.id == action.params[0].issue_id && req.body.action === 'edited') {
                    let text = 'Issue : ' + req.body.issue.id + 'repo : ' + req.body.repository.full_name + '\n' + 'as been updated' + req.body.issue.url + '\n' + req.body.changes;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
                break;
            case 'pull_request':
                if (action.action_type === 'new_pull_request' && req.body.pull_request && req.body.action === 'opened') {
                    let text = 'New pull request on ' + req.body.repository.full_name + '\n' + req.body.pull_request.title + '\n' + req.body.pull_request.url;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
                if (action.action_type === 'closed_pull_request' && req.body.pull_request && req.body.action === 'closed') {
                    let text = 'A pull request as been closed on ' + req.body.repository.full_name + '\n' + req.body.pull_request.title + '\n' + req.body.pull_request.url;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
                if (action.action_type === 'on_pull_request_edit' && req.body.pull_request && req.body.pull_request.id == action.params[0].pull_request_id && req.body.action === 'edited') {
                    let text = 'Pull request : ' + req.body.pull_request.id + 'repo : ' + req.body.repository.full_name + '\n' + 'as been updated' + req.body.pull_request.url + '\n' + req.body.changes;
                    let action_params = [{
                        body: text,
                        text: text,
                        subject: text,
                    }];
                    file.doReaction(reaction, action_params);
                }
        }

        res.status(200).send();
    })
}

async function doReaction(reaction, action_params) {
    let params = reaction.params;

    let user = await db.user.findUnique({
        where: {id: reaction.user_id},
        include: {
            auths: true,
            actions: true,
            reactions: true,
        }
    })
    let auth = await db.auth.findUnique({
        where: {id: reaction.auth_id}
    });
    let owner = await axios.get('https://api.github.com/user', {
        headers: {
            Authorization: `token ${auth.access_token}`
        }
    })
    owner = owner.data.login;

    switch (reaction.reaction_type) {
        case 'create_issue':
            await axios.post(`https://api.github.com/repos/${owner}/${params[0].repo}/issues`, {
                    accept: 'application/vnd.github.v3+json',
                    title: params[0].title,
                    body: params[0].body + '\n Message: ' + action_params[0].text,
                },
                {
                    headers: {
                        Authorization: `token ${auth.access_token}`
                    }
                })
            break;
        case 'create_pull_request':
            await axios.post(`https://api.github.com/repos/${owner}/${params[0].repo}/pulls`, {
                    accept: 'application/vnd.github.v3+json',
                    title: params[0].title,
                    head: params[0].head,
                    base: params[0].base,
                    body: params[0].body + '\n Message: ' + action_params[0].text,
                },
                {
                    headers: {
                        Authorization: `token ${auth.access_token}`
                    }
                })
            break;
    }
}

module.exports = {
    create_reaction,
    create_action,
    delete_action,
    set_webhook,
    doReaction
};