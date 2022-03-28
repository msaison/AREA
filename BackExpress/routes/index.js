const express = require('express')
const router = express.Router()

const {services_config} = require("../config/servicesconfig");
const actions = require('../methods/actions')

// method : post
// auth0_id : auth0 id
router.get('/user/id', async (req, res) => {
    let user;
    try {
        user = await actions.first_authenticate(req.query.auth0_id)
    } catch (e) {
        Sentry.captureException(e);
        return res.status(500).send(JSON.parse(e.message))
    }

    res.status(200).send({ id: user.id })
})

router.get('/about.json', async (req, res) => {
    let about = {
       "client": {
           "host": req.connection.remoteAddress,
        },
        "server": {
           "current_time": Math.floor(new Date().getTime() / 1000),
           "services": services_config.map(service => {
               return {
                   "name": service.name,
                   "actions": service.actions.map(action => {
                       return {
                           "name": action.type,
                           "description": action.desc,
                       }
                   }),
                   "reactions": service.reactions.map(reaction => {
                       return {
                           "name": reaction.type,
                           "description": reaction.desc,
                       }
                   })
               }
           })
        }
    }


    res.status(200).send(about)
})

const services_routes = require('../services/routes')
services_routes.init(router)

const auths_routes = require('../auths/routes')
const Sentry = require("@sentry/node");
auths_routes.init(router)

module.exports = router

// const { PrismaClient } = require('@prisma/client');
// const prisma = new PrismaClient()

// async function main() {
// 	const allUsers = await prisma.user.findMany()
// 	console.log(allUsers)
// }
//
// main()
// 	.catch((e) => {
// 		throw e
// 	})
// 	.finally(async () => {
// 		await prisma.$disconnect()
// })
