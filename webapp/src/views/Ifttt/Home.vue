<template>
  <div class="home" v-if="$auth.isAuthenticated">
    <div class="iftttheader">
      <span class="headerTitle">Create Your own</span>
    </div>
    <div class="body">
      <div class="container cc">
				<div @click="resetPage()" class="reset-btn">
					reset
				</div>
        <div class="row action-btn-container">
          <div class="col-8">
            <h1 class="ifttt-title">If This</h1>
          </div>
          <div class="col-4 btn-container">
            <router-link to="/service" class="btn-add">
              <div class="btn-custom">
                <div v-if="!getTriggerBool()">Add</div>
								<div v-else>modify</div>
              </div>
            </router-link>
          </div>
        </div>
        <div class="row reaction-btn-container">
          <div class="col-8">
            <h1 class="ifttt-title">Then That</h1>
          </div>
          <div class="col-4 btn-container">
            <div v-if="getTriggerBool()" class="btn-add">
              <router-link to="/service_rea">
                <div class="btn-custom">Add</div>
              </router-link>
            </div>
          </div>
        </div>
				<div v-if="isAppletFill()" class="addApplet_btn_container">
					<div class="addApplet_btn" @click="addApplet()">
						<span class="addApplet_btn_text">Add your Applet</span>
					</div>
				</div>
      </div>
    </div>
  </div>
</template>

<script>

const axios = require('axios').default;
import {back_url} from '../../globals'

export default {
  name: "home",
  data() {
    return {
			userId: null
		};
  },
  methods: {
    getTriggerBool() {
      return sessionStorage.getItem("trigger_isAuth");
    },
    isAppletFill() {
      return sessionStorage.getItem("newApplet");
    },
		async addApplet() {
      let id = this.$auth.user.sub;
      if (id != undefined)
        this.userId = id.substring(this.$auth.user.sub.indexOf("|") + 1);
			let trigger_service = sessionStorage.getItem('trigger_service')
			let trigger_type = sessionStorage.getItem('trigger_type')
			let trigger_params = sessionStorage.getItem('trigger_params')
			let reaction_service = sessionStorage.getItem('reaction_service')
			let reaction_type = sessionStorage.getItem('reaction_type')
			let reaction_params = sessionStorage.getItem('reaction_params')

			console.log('trigger_service: ' + trigger_service + '\n' + 'trigger_type: ' + trigger_type + '\n' + 'reaction_service: ' + reaction_service + '\n' + 'reaction_type: ' + reaction_type + "\n params: " + reaction_params)
			let response = await axios.post(`${back_url}/user/services/reaction/create`, {
				header: [],
					"auth0_id": this.userId,
					"auth_type": reaction_service != 'GMAIL' ? reaction_service : 'GOOGLE',
					"service_type": reaction_service != 'GOOGLE' ? reaction_service : 'GMAIL',
					"reaction_type": reaction_type,
					"params": JSON.parse(reaction_params)
			})
			axios.post(`${back_url}/user/services/action/create`, {
				header: [],
					"auth0_id": this.userId,
					"auth_type": trigger_service,
					"service_type": trigger_service,
					"action_type": trigger_type,
					"params": JSON.parse(trigger_params),
					'reaction_id': response.data.id
			})
			sessionStorage.clear()
			this.$router.push(`/applets`);
		},
		resetPage() {
			sessionStorage.clear()
			location.reload()
		}
  },
  mounted() {
    console.log("/home");
  },
};
</script>

<style>
* {
  text-decoration: none;
}

.iftttheader {
  width: 100vw;
  height: 10vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.headerTitle {
  font-weight: bold;
  font-size: 50px;
  color: #0e0e0e;
}

.body {
  padding: 100px;
  font-family: system-ui;
  height: 80vh;
  display: flex;
  justify-content: center;
  align-items: center;
}
.cc {
  width: 50%;
}
.iftttcontroler {
  height: 90vh;
  color: white;
  background-color: purple;
}
.ifttt-title {
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
  font-size: 70px;
  font-weight: bold;
  height: 100%;
}
.btn-container {
  display: flex;
  justify-content: center;
  align-items: center;
  color: black;
}

.action-btn-container {
  background-color: #000000;
  border-radius: 10px;
  text-align: center;
  width: 100%;
  height: 13vh;
  margin: 50px 0px;
}

.reaction-btn-container {
  background-color: #a0a0a0;
  border-radius: 10px;
  text-align: center;
  width: 100%;
  height: 13vh;
  margin: 50px 0px;
}
.btn-add {
  background-color: white;
  padding: 20px;
  width: 200px;
  border-radius: 100px;
  cursor: pointer;
  text-align: center;
}
.btn-add:hover {
  background-color: rgb(180, 180, 180);
  transition-duration: 0.4s;
}

.btn-custom {
  color: black;
  font-size: 20px;
  font-weight: bold;
}

.addApplet_btn_container {
	display: flex;
	justify-content: center;
	align-items: center;
}

.addApplet_btn {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100px;
	width: 200px;
	color: white;
	background-color: black;
	border-radius: 100px;
	cursor: pointer;
	font-weight: bold;
}
.reset-btn {
	cursor: pointer;
	color: black;
	text-align: center;
}
</style>