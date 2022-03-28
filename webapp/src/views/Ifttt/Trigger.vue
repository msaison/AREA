<template>
  <div class="ifttttrigger">
    <div class="styletrigger-container stcontainer">
      <div class="logotrigger-container">
        <img :src="logo_url" alt="service logo" width="200" height="200" />
      </div>
      <div class="nametrigger-container">
        <h1 class="nametrigger">{{ url_data }}</h1>
      </div>
    </div>
    <div class="grid-container">
      <grid-layout
        :layout.sync="layout"
        :col-num="colNum"
        :row-height="30"
        :is-draggable="false"
        :is-resizable="false"
        :is-mirrored="false"
        :vertical-compact="true"
        :margin="[0, 0]"
        :use-css-transforms="true"
      >
        <grid-item
          class="stcontainer myGridItem"
          v-for="item in layout"
          :x="item.x"
          :y="item.y"
          :w="item.w"
          :h="item.h"
          :i="item.i"
          :key="item.i"
        >
          <div @click="triggerSelected(item.i)">
            {{ item.i }}
          </div>
        </grid-item>
      </grid-layout>
    </div>
  </div>
</template>

<script>
import { GridLayout, GridItem } from "vue-grid-layout";
import { back_url } from "../../globals";
const axios = require("axios").default;

export default {
  components: {
    GridLayout,
    GridItem,
  },
  data() {
    return {
      layout: [],
      draggable: true,
      resizable: true,
      colNum: 24,
      index: 0,
      url_data: null,
      logo_url: null,
      apiActions: null,
      color: "#",
      userId: null,
    };
  },
  mounted() {
    this.index = this.layout.length;
    this.url_data = this.$route.params.servicename;
    axios
      .get(`${back_url}/services/action`)
      .then((response) => {
        this.apiActions = response.data;
        for (let i = 0, _x = 0; this.apiActions[i] != null; i++) {
          if (this.apiActions[i].name == this.url_data) {
            this.logo_url = this.apiActions[i].logo;
            this.color += this.apiActions[i].code_hex;
            var dd = document.getElementsByClassName("stcontainer");
            for (let i = 0; dd[i] != null; i++) {
              dd[i].style.setProperty("--trigger-bg-color", this.color);
            }
            for (let _i = 0; this.apiActions[i].actions[_i] != null; _i++) {
              this.layout.push({
                x: _x + 2,
                y: 0,
                w: 10,
                h: 2,
                i: this.apiActions[i].actions[_i].type,
                content: this.apiActions[i],
              });
              _x += 2;
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
    triggerSelected: async function (trig_name) {
      let id = this.$auth.user.sub;
      if (id != undefined)
        this.userId = id.substring(this.$auth.user.sub.indexOf("|") + 1);
      let _service = sessionStorage.getItem("trigger_service");
      let response = await axios.post(`${back_url}/user/services/connected`, {
        header: [],
        auth0_id: this.userId,
        service_type: _service,
      });
      if (!response.data.is_connected) {
        sessionStorage.setItem("trigger_type", trig_name);
        this.$router.push(`/connect/` + this.url_data);
      } else {
        sessionStorage.setItem("trigger_type", trig_name);
        sessionStorage.setItem("trigger_isAuth", true);
        this.$router.push(`/params`);
      }
    },
  },
};
</script>

<style>
* {
  text-decoration: none !important;
}

:root {
  --trigger-bg-color: rgb(255, 255, 255);
}

.styletrigger-container {
  height: 50vh;
  width: 100vw;
  background-color: var(--trigger-bg-color);
}

.logotrigger-container {
  height: 30vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
}

.nametrigger-container {
  height: 10vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
}

.nametrigger {
  font-family: system-ui;
  font-size: 80px;
  font-weight: bold;
  color: white;
}

.grid-container {
  width: 100%;
  padding: 100px;
  padding-left: 17vw;
}

.vue-grid-layout {
  background-color: none;
}
.myGridItem {
  background-color: var(--trigger-bg-color);
  color: black !important;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 30px;
  font-weight: bold;
}
.myGridItem:hover {
  cursor: pointer;
  animation: trigAnim 0.4s forwards;
}

@keyframes trigAnim {
  from {
  }
  to {
    color: white;
  }
}

.po-btn {
  height: 50%;
  width: 100%;
}

.po-txt-btn {
  height: 50%;
  width: 100%;
}
</style>