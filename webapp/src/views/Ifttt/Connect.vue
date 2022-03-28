<template>
  <div class="connect">
    <div class="top-container stcontainer">
      <div class="logotrigger-container">
        <img :src="logo_url" alt="service logo" width="200" height="200" />
      </div>
      <div class="titleconnect-container">
        <h1 class="titleconnect">{{ url_data }}</h1>
      </div>
      <div class="connect-span-container">
        <span class="connect-span">
          …où tu pourrais faire partie d'un club scolaire, d'un groupe de gamers
          ou d'une communauté d'art internationale. Un endroit où toi et ta
          bande d'amis pouvez simplement passer du temps ensemble. Un endroit
          qui permettrait plus facilement de discuter tous les jours et de se
          retrouver plus souvent. Grâce aux chats vocaux et vidéo à faible
          latence, les interlocuteurs ont l'impression d'être dans la même
          pièce. Fais un petit coucou par vidéo, regarde tes amis streamer leurs
          jeux, ou profitez du partage d'écran pour faire une session de dessin
          ensemble.
        </span>
      </div>
      <div class="connect-btn-container">
        <div @click="serviceConnect()" class="connect-btn">Connect</div>
      </div>
    </div>
  </div>
</template>

<script>
const axios = require("axios").default;
import { back_url } from "../../globals";

export default {
  components: {},
  data() {
    return {
      url_data: null,
      logo_url: null,
      apiActions: null,
      color: "#",
      userId: "",
    };
  },
  mounted() {
    this.url_data = this.$route.params.servicename;
    axios
      .get(`${back_url}/services/action`)
      .then((response) => {
        this.apiActions = response.data;
        for (let i = 0; this.apiActions[i] != null; i++) {
          if (this.apiActions[i].name == this.url_data) {
            this.logo_url = this.apiActions[i].logo;
            this.color += this.apiActions[i].code_hex;
            var dd = document.getElementsByClassName("stcontainer");
            for (let i = 0; dd[i] != null; i++) {
              dd[i].style.setProperty("--trigger-bg-color", this.color);
            }
          }
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  },
  probs: {
    servicename: { type: String, required: true },
  },
  methods: {
    serviceConnect() {
      let id = this.$auth.user.sub;
      if (id != undefined)
        this.userId = id.substring(this.$auth.user.sub.indexOf("|") + 1);
      else return;
      let _service = sessionStorage.getItem('trigger_service')
      axios
        .post(`${back_url}/user/auth/create`, {
          headers: ["Bypass-Tunnel-Reminder"],
          auth0_id: this.userId,
          auth_type: _service
        })
        .then((response) => {
          console.log(response.data);
          sessionStorage.setItem("trigger_isAuth", true);
          if (sessionStorage.getItem("trigger_service") == 'CRONHOOK')
            this.$router.push('/params')
          window.location.href = response.data.redirect_uri;
        })
        .catch(() => {
          console.log("error in post user auth of service");
        });
    },
  },
};
</script>
    
<style>
:root {
  --trigger-bg-color: rgb(255, 255, 255);
}

.top-container {
  height: 90vh;
  width: 100vw;
  background-color: var(--trigger-bg-color);
}

.titleconnect-container {
  height: 10vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
}

.titleconnect {
  font-family: system-ui;
  font-size: 80px;
  font-weight: bold;
  color: white;
}

.connect-span-container {
  width: 100vw;
  height: 30vh;

  display: flex;
  justify-content: center;
  align-items: center;
}

.connect-span {
  color: white;
  font-size: 20px;
  letter-spacing: 1px;
  width: 50%;
}

.connect-btn-container {
  width: 100vw;
  height: 10vh;

  display: flex;
  justify-content: center;
  align-items: center;
}

.connect-btn {
  height: 80%;
  width: 200px;
  padding: 10px;
  background-color: white;
  border-radius: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: black;
  font-weight: bold;
  font-family: system-ui;
  font-size: 25px;
}
.connect-btn:hover {
  cursor: pointer;
}
</style>