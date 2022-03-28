// Define routes for services

const {auths, auth_controllers} = require("../config/authconfig");
const {services_config, service_controllers} = require("../config/servicesconfig");
const {db} = require("../config/dbconfig");
const method_actions = require("../methods/actions");
const Sentry = require("@sentry/node");

function init(router) {

    // method : get
    router.get('/services', async (req, res) => {
        let user, db_auths, json;
        try {
            user = await method_actions.authenticate(req.query.auth0_id)
            db_auths = await db.auth.findMany({where: {user_id: user.id}})

            json = services_config.map((value_) => {
                if (db_auths.length > 0) {
                    db_auths.forEach((value) => {
                        value_['is_connected'] = value_.type === value.type
                        })
                } else
                    value_['is_connected'] = false;
                return value_;
            })
        } catch (e) {
            console.log('Error : ' + e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        res.send(json)
    })

    // method : get
    router.get('/services/action', (req, res) => {
        let json = services_config

        json = json.filter((element) => {
            return element.actions.length !== 0
        })

        res.send(json)
    })

    // method : get
    router.get('/services/reaction', (req, res) => {
        let json = services_config

        json = json.filter((element) => {
            return element.reactions.length !== 0
        })

        res.send(json)
    })

    // method : get
    // auth0_id : string
    router.get('/user/applets', async (req, res) => {
        let user, actions, reactions, applets;
        try {
            user = await method_actions.authenticate(req.query.auth0_id)
            actions = await db.action.findMany({ where: {user_id: user.id}})
            reactions = await db.reaction.findMany({where: {user_id: user.id}})

            applets = actions.map((action) => {
                let reaction = reactions.find((reaction) => {return action.reaction_id === reaction.id})
                action.service = JSON.parse(JSON.stringify(method_actions.get_service_config(action.service_type)))
                reaction.service = JSON.parse(JSON.stringify(method_actions.get_service_config(reaction.service_type)))

                let reaction_reactions_filtered
                reaction.service.reactions.forEach((reaction_) => {
                    if (reaction_.type === reaction.reaction_type)
                        reaction_reactions_filtered = reaction_
                })

                let action_actions_filtered
                action.service.actions.forEach((action_) => {
                    if (action_.type === action.action_type)
                        action_actions_filtered = action_
                })


                reaction.service.actions = []
                action.service.actions = [action_actions_filtered]

                action.service.reactions = []
                reaction.service.reactions = [reaction_reactions_filtered]

                return {action: action, reaction: reaction}
            })
        } catch (e) {
            console.log('Error : ' + e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        res.send(applets)
    })

    // method : get
    // auth0_id : string
    // reaction_id : reaction_id
    router.get('/user/applets/destroy', async (req, res) => {
        let user, action, reaction;
        try {
            user = await method_actions.authenticate(req.query.auth0_id)

            action = await db.action.findUnique({where: {reaction_id: Number(req.query.reaction_id)}})
            await db.action.delete({where: {reaction_id: Number(req.query.reaction_id)}})

            reaction = await db.reaction.findUnique({where: {id: Number(req.query.reaction_id)}})
            await db.reaction.delete({where: {id: Number(req.query.reaction_id)}})

            const controller = service_controllers[action.service_type];
            let file = eval(controller);
            file.delete_action(action, user, user.auths, action.params);
        } catch (e) {
            console.log('Error : ' + e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        res.status(200).send({result: `Applet (action : ${action.id}, reaction : ${reaction.id}) deleted`})
    })

    // method : get
    // auth0_id : string
    router.get('/user/services/action', async (req, res) => {
        let user, actions;
        try {
            user = await method_actions.authenticate(req.query.auth0_id)
            actions = await db.action.findMany({where: {user_id: user.id}})
        } catch (e) {
            console.log('Error : ' + e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        res.send(actions)
    })

    // method : get
    // auth0_id : string
    router.get('/user/services/reaction', async (req, res) => {
        let user, reactions;
        try {
            user = await method_actions.authenticate(req.query.auth0_id)
            reactions = await db.reaction.findMany({where: {user_id: user.id}})
        } catch (e) {
            console.log('Error : ' + e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }
        res.send(reactions)
    })

    // method : post
    // auth0_id : auth0 id
    // service_type : service type
    router.post('/user/services/connected', async (req, res) => {
        let user, service_type, available_auths, connected_auths, connected_available_auths;
        try {
            user = await method_actions.authenticate(req.body.auth0_id)
            service_type = method_actions.check_service_type(req.body.service_type)
            available_auths = method_actions.get_service_config(req.body.service_type).available_auths
        } catch (e) {
            console.log('Error : ' + e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        try {
            connected_auths = method_actions.get_connected_auths(user)
        } catch (e) {
            console.log('no auths for user : ', user.id)
            Sentry.captureException(e);
            return (res.send({
                'is_connected': false,
                'auths': available_auths,
            }));
        }

        try {
            connected_available_auths = method_actions.get_connected_available_auths(connected_auths, available_auths)
        } catch (e) {
            console.log('No available connected auths for user : ', user.id)
            Sentry.captureException(e);
            return (res.send({
                'is_connected': false,
                'auths': available_auths,
            }));
        }

        res.send({
                'is_connected': true,
                'auths': connected_available_auths,
        })
    })

    // method : post
    // auth0_id : auth0 id
    // service_type : service type
    // reaction_type : reaction type
    router.post('/user/services/reaction/create', async (req, res) => {
        let user, reaction, service_type, available_auths, connected_auths, reaction_type, connected_available_auths;
        try {
            user = await method_actions.authenticate(req.body.auth0_id)
            service_type = method_actions.check_service_type(req.body.service_type)
            reaction_type = method_actions.check_reaction_type(service_type, req.body.reaction_type)
            available_auths = method_actions.get_service_config(req.body.service_type).available_auths
            connected_auths = method_actions.get_connected_auths(user)
            connected_available_auths = method_actions.get_connected_available_auths(connected_auths, available_auths)


            let params = req.body.params
            let auth = user.auths.find((element) => {
                return element.type === connected_available_auths[0]
            })

            reaction = await db.reaction.create({
                data: {
                    user_id: user.id,
                    service_type: service_type,
                    auth_id: auth.id,
                    reaction_type: reaction_type,
                    params: params,
                }
            });

            if (!reaction) return res.status(500).send({result: `unable to create reaction_type: ${reaction_type}`})

            const controller = service_controllers[service_type];
            let file = eval(controller);
            file.create_reaction(reaction, user, auth, params);
        } catch (e) {
            console.log('Error : ', e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        res.status(200).send({result: `reaction_type: ${reaction_type} created`, id: reaction.id})
    })

    // method : post
    // auth0_id : auth0 id
    // service_type : service type
    // action_type : action type
    // reaction_id : reaction id
    router.post('/user/services/action/create', async (req, res) => {
        let user, service_type, available_auths, connected_auths, action_type, connected_available_auths;
        try {
            user = await method_actions.authenticate(req.body.auth0_id)
            service_type = method_actions.check_service_type(req.body.service_type)
            action_type = method_actions.check_action_type(service_type, req.body.action_type)
            available_auths = method_actions.get_service_config(req.body.service_type).available_auths
            connected_auths = method_actions.get_connected_auths(user)
            connected_available_auths = method_actions.get_connected_available_auths(connected_auths, available_auths)

            let params = req.body.params
            let auth = user.auths.find((element) => {
                return element.type === connected_available_auths[0]
            })

            let action = await db.action.create({
                data: {
                    user_id: user.id,
                    service_type: service_type,
                    reaction_id: Number(req.body.reaction_id),
                    auth_id: auth.id,
                    action_type: action_type,
                    params: params,
                }
            });

            if (!action) return res.status(500).send({result: `unable to create action_type: ${action_type}`})

            const controller = service_controllers[service_type];
            let file = eval(controller);
            file.create_action(action, user, auth, params);
        } catch (e) {
            console.log('Error : ', e)
            Sentry.captureException(e);
            return res.status(500).send('Error : ' + e)
        }

        res.status(200).send({result: `action_type: ${action_type} created`})
    })
}

module.exports = {init: init}

    // all available services
//
// for (let service in services) {
//     let available_auth = service_helper.find(service).available_auths
//
//     var _ = require('underscore');
//     let compatible_auths = _.intersection(user_auths_types, available_auth)
//
//     available_services.push({
//         name: service_helper.find(service).name,
//         is_connected: true,
//         via: compatible_auths,
//     })
// }
