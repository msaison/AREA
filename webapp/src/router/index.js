import Vue from 'vue'
import VueRouter from 'vue-router'
import Profile from "../views/Profile.vue";

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Ifttt/Home')
  },
  {
    path: '/applets',
    name: 'applets',
    component: () => import('../views/Applets.vue')
  },
  {
    path: "/profile",
    name: "profile",
    component: Profile
  }, 
  {
    path: '/service',
    name: 'service',
    component: () => import('../views/Ifttt/Service.vue'),
  },
  {
    path: '/service_rea',
    name: 'service_rea',
    component: () => import('../views/Ifttt/Service_rea.vue'),
  },
  {
    path: '/action/:servicename',
    name: 'action',
    component: () => import('../views/Ifttt/Trigger.vue'),
    probs: true,
  },
  {
    path: '/reaction/:servicename',
    name: 'reaction',
    component: () => import('../views/Ifttt/Reaction.vue'),
    probs: true,
  },
  {
    path: '/params',
    name: 'params',
    component: () => import('../views/Ifttt/Params.vue'),
    probs: true,
  },
  {
    path: '/params_rea',
    name: 'params_rea',
    component: () => import('../views/Ifttt/Params_rea.vue'),
    probs: true,
  },
  {
    path: '/connect/:servicename',
    name: 'connect',
    component: () => import('../views/Ifttt/Connect.vue'),
    probs: true,
  },
  {
    path: '/connect_rea/:servicename',
    name: 'connect_rea',
    component: () => import('../views/Ifttt/Connect_rea.vue'),
    probs: true,
  },
  {
    path: '/client.apk',
    name: 'dlapk',
    component: () => import('../dlapk.js'),
    probs: true,
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
