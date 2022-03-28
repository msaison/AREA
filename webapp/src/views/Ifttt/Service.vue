<template>
    <div class="iftttservice">
        <div class="serviceHeader">
            <span class="serviceTitle">Choose a service</span>
        </div>
		<SearchBar placeHolder="Search services"/>
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
                <grid-item class="gridElement" id="gi-unique" v-for="item in layout"
                        :x="item.x"
                        :y="item.y"
                        :w="item.w"
                        :h="item.h"
                        :i="item.i"
                        :key="item.i">
                        <div @click="serviceSelected(item.content)">
                        {{item.i}}
                        </div>
                    <!-- <router-link id="rl-btn" :to="'/action/' + item.i">
                        <div id="rl-txt-btn">
                            {{item.i}}
                        </div>
                    </router-link> -->
                </grid-item>
            </grid-layout>
        </div>
    </div>
</template>

<script>

import { GridLayout, GridItem } from "vue-grid-layout"
import SearchBar from '../../components/SearchBar.vue'
import {back_url} from '../../globals'
import {_newApplet} from '../../_classAppelet'

const axios = require('axios').default;

export default {
    components: {
        GridLayout,
        GridItem,
        SearchBar,
    },
    data() {
        return {
            tmpLayout: [],
            layout: [],
            draggable: false,
            resizable: false,
            colNum: 12,
            index: 0,
            backgroundColor: '',
            apidata: null,
        }
    },
    mounted() {
        this.index = this.layout.length;
        this.layout = []
        this.tmpLayout = this.layout;

        axios.get(`${back_url}/services/action`, {
			'Bypass-Tunnel-Reminder': ''
		})
        .then(response => {
            this.apidata = response.data
            for (let i = 0, _x = -2; this.apidata[i] != null; i++) {
                this.layout.push({ x: _x + 2, y: 0, w: 2, h: 8, i: this.apidata[i].name, content: this.apidata[i]})
                _x += 2
            }
            console.log(this.layout)
        })
        .catch(function (error) {
            console.log(error);
        })
    },
    methods: {
        serviceSelected: function(service) {
            console.log(service)
            sessionStorage.setItem('trigger_service', service.available_auths[0]);
            sessionStorage.setItem('trigger_isAuth', false);
            sessionStorage.setItem('newApplet', false);
            _newApplet.trigger.service = service.available_auths[0]
            const path = '/action/' + service.name
            this.$router.push(path)
        }
    }
}

</script>

<style>

.serviceHeader {
    width: 100vw;
    height: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.serviceTitle {
    font-family: system-ui;
    font-size: 70px;
    font-weight: bold;
    color: black;
}

.grid-container {
    height: 60vh;
    width: 100%;
    padding: 100px;
    padding-left: 17vw;
}

#gi-unique {
    background: var(--myColor, #ececec);
}

.vue-grid-item:not(.vue-grid-placeholder) {
    border: none;
    color: #ffffff;
	display: flex;
	justify-content: center;
	align-items: center;
    font-size: 30px;
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

.vue-draggable-handle {
    position: absolute;
    width: 20px;
    height: 20px;
    top: 0;
    left: 0;
    background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='10'><circle cx='5' cy='5' r='5' fill='#999999'/></svg>") no-repeat;
    background-position: bottom right;
    padding: 0 8px 8px 0;
    background-repeat: no-repeat;
    background-origin: content-box;
    box-sizing: border-box;
    cursor: pointer;
}

.gridElement {
    cursor: pointer;
}

#gi-unique {
    display: flex;
    justify-content: center;
    align-content: center;
}

#rl-txt-btn {
    height: 10%;
}

#rl-btn {
    text-decoration: none;
    color: white;
    height: 50%;
    width: 100%;
    display: flex;
    justify-content: center;
    align-content: center;
}#rl-btn:hover {
    color: grey;
    transition-duration: 0.4s;
}
</style>