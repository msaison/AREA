// Define routes for auths

const actions = require("../methods/actions");
const {service_controllers} = require("../config/servicesconfig");
const {db} = require("../config/dbconfig");
const {auths_config} = require("../config/authconfig");
const auths = require("../config/authconfig").auths;
const auth_controllers = require("../config/authconfig").auth_controllers;
const Sentry = require("@sentry/node");

function init(router) {

    // method : get
    // auth0_id : string
    router.get('/auths', async (req, res) => {
        let user, connected_auths;

        let json = auths_config

        try {
            user = await actions.authenticate(req.query.auth0_id)
        } catch (e) {
            Sentry.captureException(e);
            console.log(e)
        }

        try {
            connected_auths = actions.get_connected_auths(user)
        } catch (e) {
            Sentry.captureException(e);
            console.log(e)
        }

        json = auths_config.map((auth) => {
            let db_auth = user.auths.find((element) => {
                return element.type === auth.type
            })

            auth.is_connected = !!(connected_auths && connected_auths.length !== 0 && connected_auths.includes(auth.type));
            auth.id = db_auth ? db_auth.id : null;
            return auth
        })

        res.send(json)
    })

    // method: post
    // auth0_id: auth0_id
    // auth_type: auth_type
    router.post('/user/auth/create', async (req, res) => {
        let user, auth_type, connected_auths;
        try {
            user = await actions.authenticate(req.body.auth0_id)
            auth_type = actions.check_auth_type(req.body.auth_type);
            connected_auths = actions.get_connected_auths(user)
        } catch (e) {
            console.log(JSON.parse(e.message));
            Sentry.captureException(e);
            return res.status(500).send(JSON.parse(e.message))
        }

        let auth;
        if (connected_auths && connected_auths.length > 0 && connected_auths.includes(auth_type)) {
            auth = connected_auths[0];
            return res.status(500).send({result: `unable to create auth_type: ${auth_type} already exists for user: ${user.id}`})
        } else {
            auth = await db.auth.create({
                data: {
                    user_id: Number(user.id),
                    type: auth_type,
                }
            })
        }

        if (!auth) return res.status(500).send({result: `unable to create auth_type: ${auth_type}`})

        const controller = auth_controllers[auth_type]; // TODO check if controller exists
        let file = eval(controller);
        let redirect_uri = await file.authorize(user, function (oAuth2Client) {
        }) // TODO try catch on create

        if (redirect_uri)
            return res.status(200).send({redirect_uri: redirect_uri})
        return res.status(201).send({result: `auth_type: ${auth_type} created`})

        // controller.create(auth) // TODO try catch on create
        //
        // //TODO differentiacte between oauth2 and others
        // if (auth_type === auths.GOOGLE) {
        //     let redirect_uri = auth_controllers.oauth2_authorize(user, function () {})
        //     return res.status(200).send({redirect_uri: redirect_uri})
        // }
        //
        // auth_controllers.authorize(user, function () {})
        // return res.status(200).send({result: `auth_type: ${auth_type} created`})
    })

    // method: post
    // auth0_id: auth0_id
    // auth_id: auth_id
    router.post('/user/auth/destroy', async (req, res) => {
        let user, db_auth;
        try {
            user = await actions.authenticate(req.body.auth0_id)
            db_auth = await db.auth.findUnique({where: {id: Number(req.body.auth_id)}})
        } catch (e) {
            console.log(JSON.parse(e.message));
            Sentry.captureException(e);
            return res.status(500).send(JSON.parse(e.message))
        }

        await db.action.deleteMany({where: {auth_id: Number(db_auth.id)}})
        await db.reaction.deleteMany({where: {auth_id: Number(db_auth.id)}})
        await db.auth.delete({where: {id: Number(req.body.auth_id)}})

        return res.status(201).send({result: `auth_type: ${db_auth.type} id : ${db_auth.id}  deleted`})
    })

    for (let controller in auth_controllers) {
        let file = eval(auth_controllers[controller]);
        file.set_callback(router);
    }

    for (let controller in service_controllers) {
        let file = eval(service_controllers[controller]);
        file.set_webhook(router);
    }
}

module.exports = {init: init}