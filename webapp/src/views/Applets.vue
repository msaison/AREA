<template>
  <div class="iftttapplets">
    <div class="space"></div>
    <div class="iftttheaderApplet">
      <span class="headerTitleApplet">My Applets</span>
    </div>
    <SearchBar placeHolder="Search applets" />
    <div class="grid-container">
      <grid-layout
        :layout.sync="layout"
        :col-num="colNum"
        :row-height="30"
        :is-draggable="false"
        :is-resizable="false"
        :is-mirrored="false"
        :vertical-compact="true"
        :margin="[20, 10]"
        :use-css-transforms="true"
      >
        <grid-item
          style="border-radius: 10px"
          v-for="item in layout"
          :x="item.x"
          :y="item.y"
          :w="item.w"
          :h="item.h"
          :i="item.i"
          :e="item.e"
          :key="item.i"
        >
          {{ item.i }}
        </grid-item>
      </grid-layout>
    </div>
  </div>
</template>

<script>
import { GridLayout, GridItem } from "vue-grid-layout";
import SearchBar from "../components/SearchBar.vue";
import { back_url } from "../globals";

const axios = require("axios").default;

export default {
  components: {
    GridLayout,
    GridItem,
    SearchBar,
  },
  data() {
    return {
      layout: [],
      draggable: true,
      resizable: true,
      colNum: 12,
      index: 0,
      userId: null,
    };
  },
  mounted() {
    this.layout = [];
    

    let id = this.$auth.user.sub != null ? this.$auth.user.sub : "id0";
    if (id != undefined)
      this.userId = id.substring(this.$auth.user.sub.indexOf("|") + 1);
    axios
      .get(`${back_url}/user/applets?auth0_id=${this.userId}`)
      .then((response) => {
        this.apidata = response.data;
        for (let i = 0, _x = -2; this.apidata[i] != null; i++) {
          this.layout.push({
            x: _x + 2,
            y: 0,
            w: 2,
            h: 8,
            i:
              this.apidata[i].action.service.actions[0].desc_applet +
              this.apidata[i].reaction.service.reactions[0].desc_applet,
          });
          _x += 2;
        }
      })
      .catch(function (error) {
        console.log("Error display appelets " + error);
      });
  },
  methods: {
    addItem: function () {
      this.layout.push({
        x: (this.layout.length * 2) % (this.colNum || 12),
        y: this.layout.length + (this.colNum || 12),
        w: 2,
        h: 2,
        i: this.index,
        e: "edit",
      });
      this.index++;
    },
    removeItem: function (val) {
      const index = this.layout.map((item) => item.i).indexOf(val);
      this.layout.splice(index, 1);
    },
    Selected: function () {
      console.log("Service post in db");
    },
  },
};
</script>

<style>
.space {
  width: 100vw;
  height: 5vh;
}

.iftttheaderApplet {
  width: 100vw;
  height: 10vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.headerTitleApplet {
  font-weight: bold;
  font-size: 70px;
  color: #0e0e0e;
}

.searchbar-container {
  width: 100vw;
  height: 10vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.searchbar {
  height: 60%;
  width: 40%;
  display: flex;
  justify-content: center;
  align-items: center;
  border: 3px solid grey;
  border-radius: 20px;
}

.icon-searchbar {
  height: 100%;
  width: 10%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.input-searchbar {
  height: 100%;
  width: 90%;
  display: flex;
  justify-content: center;
  align-items: center;
}

input[type="text"],
select {
  height: 90%;
  width: 100%;
  border-radius: 10px;
  border: none;
  font-size: 30px;
}

.grid-container {
  height: 75vh;
  width: 100%;
  padding: 100px;
  padding-left: 17vw;
}

.vue-grid-item:not(.vue-grid-placeholder) {
  background: #3b3b3b;
  border: none;
  color: #ffffff;
  font-size: 20px;
  font-family: system-ui;
  font-weight: bold;
}

.vue-grid-item .static {
  background: #cce;
  display: flex;
  justify-content: center;
  align-content: center;
}
.vue-grid-item .text {
  font-size: 24px;
  text-align: center;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
  height: 100%;
  width: 100%;
}
.vue-grid-item .no-drag {
  height: 100%;
  width: 100%;
}
.vue-grid-item .minMax {
  font-size: 30px;
}
.vue-grid-item .add {
  cursor: pointer;
}
.vue-grid-item:hover {
  cursor: pointer;
  color: grey;
}
.vue-draggable-handle {
  position: absolute;
  width: 20px;
  height: 20px;
  top: 0;
  left: 0;
  background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='10'><circle cx='5' cy='5' r='5' fill='#999999'/></svg>")
    no-repeat;
  background-position: bottom right;
  padding: 0 8px 8px 0;
  background-repeat: no-repeat;
  background-origin: content-box;
  box-sizing: border-box;
  cursor: pointer;
}
</style>