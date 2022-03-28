<template>
  <div class="params">
    <div class="top-container stcontainer">
      <div class="logotrigger-container">
        <img :src="logo_url" alt="service logo" width="200" height="200" />
      </div>
      <div class="titleparams-container">
        <h1 class="titleparams">{{ url_data }}</h1>
      </div>
      <div class="confirmParams-btn-container">
        <div class="confirmParams-btn" @click="paramsConfirm(frontParams)">
          Confirm
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
            <!-- <div class="params-btn-container">
              <div class="params-btn"> -->
            {{ item.name }}
            <br />
            <input
              type="text"
              :id="item.i"
              @input="paramsTab"
              name="changeName"
              required
              minlength="1"
              maxlength="50"
            />
          </grid-item>
        </grid-layout>
      </div>
    </div>
  </div>
</template>

<script>
import { GridLayout, GridItem } from "vue-grid-layout";

const axios = require("axios").default;
import { back_url } from "../../globals";

export default {
  components: {
    GridLayout,
    GridItem,
  },
  data() {
    return {
      layout: [],
      url_data: null,
      trig_type: null,
      logo_url: null,
      apiActions: null,
      color: "#",
      userId: "",
      frontParams: [],
      colNum: 12,
    };
  },
  async mounted() {
		if (sessionStorage.getItem('trigger_isParamsFill'))
		{
			console.log("route redirect")
			this.$router.push('/params_rea')
		}
    this.url_data = sessionStorage.getItem("trigger_service");
    this.trig_type = sessionStorage.getItem("trigger_type");
    axios
      .get(`${back_url}/services/action`)
      .then((response) => {
        this.apiActions = response.data;
        this.apiActions.forEach((element) => {
          if (element.type == this.url_data) {
            this.logo_url = element.logo;
            this.color += element.code_hex;
            var dd = document.getElementsByClassName("stcontainer");
            for (let i = 0; dd[i] != null; i++) {
              dd[i].style.setProperty("--trigger-bg-color", this.color);
            }
            element.actions.forEach((element_) => {
              if (element_.type == this.trig_type) {
                if (element_.params.length > 0) {
                  for (let i = 0, _x = 0; i < element_.params.length; i++) {
                    var obj = {};
                    obj[element_.params[i].name] = "";
                    this.frontParams.push(obj);
                    this.layout.push({
                      x: _x + 2,
                      y: 0,
                      w: 10,
                      h: 3,
                      i: i,
                      name: element_.params[i].name,
                    });
                    _x += 2;
                  }
                } else {
                  sessionStorage.setItem("trigger_params", JSON.stringify([{ "": "" }]));
									sessionStorage.setItem("trigger_isParamsFill", true);
                  this.$router.push("/");
                }
              }
            });
          }
        });
      })
      .catch(function (error) {
        console.log(error);
      });
  },
  probs: {},
  methods: {
    getInputId(i) {
      return `inputId${i}`;
    },
    paramsTab() {
      for (let i = 0; i < this.frontParams.length; i++) {
        let key_name = Object.keys(this.frontParams[i])[0].toString();
        this.frontParams[i][key_name] = document.getElementById(i).value
      }
      sessionStorage.setItem("trigger_params", JSON.stringify(this.frontParams))
    },
    paramsConfirm() {
      sessionStorage.setItem("trigger_isParamsFill", true);
      this.$router.push("/");
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

.titleparams-container {
  height: 10vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
}

.titleparams {
  font-family: system-ui;
  font-size: 80px;
  font-weight: bold;
  color: white;
}

.params-span-container {
  width: 100vw;
  height: 30vh;

  display: flex;
  justify-content: center;
  align-items: center;
}

.params-span {
  color: white;
  font-size: 20px;
  letter-spacing: 1px;
  width: 50%;
}

.params-btn-container {
  width: 100vw;
  height: 10vh;

  display: flex;
  justify-content: center;
  align-items: center;
}

.params-btn {
  padding: 10px;
  border-radius: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: black;
  font-weight: bold;
  font-family: system-ui;
  font-size: 25px;
}
.params-btn:hover {
  cursor: pointer;
}

.confirmParams-btn-container {
  display: flex;
  justify-content: center;
  align-items: center;
}

.confirmParams-btn {
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: bold;
  color: white;
  background-color: black;
  border-radius: 100px;
  height: 100px;
  width: 200px;
  font-size: 25px;
  cursor: pointer;
}
</style>