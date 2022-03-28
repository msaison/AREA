<template>
  <div id="app">
    <div id="nav">
      <NavBar />
    </div>
    <div v-if="$auth.isAuthenticated">
      {{ postId($auth) }}
      <router-view />
    </div>
    <div v-else>
      <div class="loader-container">
        <half-circle-spinner
          :animation-duration="1000"
          :size="100"
          color="#000000"
        />
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from "./components/NavBar";
import { HalfCircleSpinner } from "epic-spinners";
import { back_url } from "./globals";

const axios = require("axios").default;

export default {
  components: {
    NavBar,
    HalfCircleSpinner,
  },
  data() {
    return {
      userId: "",
      isCo: false,
    };
  },
  methods: {
    postId: function (_auth) {
      if (!this.isCo) {
        let id = _auth.user.sub;
        if (id != undefined)
          this.userId = id.substring(_auth.user.sub.indexOf("|") + 1);
        else return;
        axios
          .get(`${back_url}/user/id?auth0_id=${this.userId}`)
          .then(() => {
            console.log(this.userId);
            this.isCo = true;
          })
          .catch(() => {
            console.log("error in post id");
          });
      } else {
        return;
      }
    },
  },
  mounted() {
    console.log("App started");
  },
};
</script>

<style>
html {
  scroll-behavior: smooth;
}
body {
  margin: 0;
  font-family: system-ui;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}

.loader-container {
  width: 100vw;
  height: 50vh;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
