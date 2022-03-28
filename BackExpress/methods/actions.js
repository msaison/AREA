const {services, services_config} = require("../config/servicesconfig");
const db = require('../config/dbconfig').db
const _ = require("underscore");
const {auths} = require("../config/authconfig");

var functions = {
    first_authenticate: async function (auth0_id) {
        if (!auth0_id) {
            console.log('No auth0_id provided')
            throw new Error(JSON.stringify({result: 'No auth0_id provided'}))
        }

        let user = await db.user.findUnique({
            where: { auth0_id: auth0_id },
            include: {
                auths: true,
                actions: true,
                reactions: true,
            }
        })

        if (!user) {
            user = await db.user.create({
                data: { auth0_id: auth0_id },
            })
        }

        return (user)
    },

    authenticate: async function (auth0_id) {
        if (!auth0_id) {
            console.log('No auth0_id provided')
            throw new Error(JSON.stringify({result: 'No auth0_id provided'}))
        }

        let user = await db.user.findUnique({
            where: { auth0_id: auth0_id },
            include: {
                auths: true,
                actions: true,
                reactions: true,
            }
        })

        if (!user) {
            console.log('User does not exist in database auth0_id: ' + auth0_id)
            throw new Error(JSON.stringify({result: `User does not exist in database auth0_id : ${auth0_id}`}))
        }

        return (user)
    },

    check_auth_type: function (auth_type) {
        if (!auth_type) {
            console.log('No auth_type provided')
            throw new Error(JSON.stringify({result: 'No auth_type provided'}))
        }

        if (!auths[auth_type]) {
            console.log("auth_type not found req : ", auth_type)
            throw new Error(JSON.stringify({result:`auth_type not found req : ${auth_type}`}));
        }

        return (auth_type)
    },

    check_reaction_type: function (service_type, reaction_type) {
        if (!reaction_type) {
            console.log('No reaction_type provided')
            throw new Error(JSON.stringify({result: 'No reaction_type provided'}))
        }
        if (!this.get_service_config(service_type).reactions.map(reaction => reaction.type).includes(reaction_type)) {
            console.log("reaction_type not found req : ", reaction_type)
            throw new Error(JSON.stringify({result:`reaction_type not found req : ${reaction_type}`}));
        }

        return (reaction_type)
    },

    check_action_type: function (service_type, action_type) {
        if (!action_type) {
            console.log('No action_type provided')
            throw new Error(JSON.stringify({result: 'No action_type provided'}))
        }

        if (!this.get_service_config(service_type).actions.map(action => action.type).includes(action_type)) {
            console.log("action_type not found req : ", action_type)
            throw new Error(JSON.stringify({result:`action_type not found req : ${action_type}`}));
        }

        return (action_type)
    },

    check_service_type: function (service_type) {
        if (!service_type) {
            console.log('No service_type provided')
            throw new Error(JSON.stringify({result: 'No service_type provided'}))
        }

        if (!services[service_type]) {
            console.log("service_type not found req : ", service_type)
            throw new Error(JSON.stringify({result:`service_type not found req : ${service_type}`}));
        }

        return (service_type)
    },

    get_service_config: function (service_type) {
        if (!service_type) {
            console.log('No service_type provided')
            throw new Error(JSON.stringify({result: 'No service_type provided'}))
        }

        if (!services[service_type]) {
            console.log("service_type not found req : ", service_type)
            throw new Error(JSON.stringify({result:`service_type not found req : ${service_type}`}));
        }

        let service_config = services_config.filter(function (service) {
            return service.type === service_type
        })
        if (service_config.length === 0) {
            console.log("service_config not found req : ", service_type)
            throw new Error(JSON.stringify({result:`service_config not found req : ${service_type}`}));
        }

        return (service_config[0])
    },

    get_connected_auths: function (user) {
        let connected_auths = user?.auths?.map((element) => { return element.type; })

        return (connected_auths)
    },

    get_connected_available_auths: function (connected_auths, available_auths) {
        let connected_available_auths = _.intersection(connected_auths, available_auths) //TODO : for multiple auths

        if (connected_available_auths.length === 0) {
            console.log("No available and connected auths connected_auths : ", connected_auths)
            throw new Error(JSON.stringify({result:`No available and connected auths connected_auths : ${connected_auths}`}));
        }

        return (connected_available_auths)
    },
}

module.exports = functions