<template>
    <div class="navbar">
        <div class="container">
            <div class="row cc">
                <div class="col-1">

                </div>
                <div class="col-1">
                    <router-link to="/" v-if="$auth.isAuthenticated">
                        <button class="nav-btn">Home</button>
                    </router-link>
                </div>
                <div class="col-2">
                    <router-link to="/applets" v-if="$auth.isAuthenticated">
                        <button class="nav-btn">Applets</button>
                    </router-link>
                </div>
                <div class="col-5">

                </div>
                <div class="col-2 login-btn">
                    <div v-if="!$auth.loading">
                        <button class="nav-btn" v-if="!$auth.isAuthenticated" @click="login">Log in</button>
                        
                        <router-link v-if="$auth.isAuthenticated" to="/Profile">
                            <button class="nav-btn">{{ $auth.user.given_name }}</button>
                            <img id="nav-profilpic" :src="$auth.user.picture" alt="" height="50" width="50">
                        </router-link>
                    </div>
                </div>
                <div class="col-1">

                </div>
            </div>
        </div>
    </div>
</template>

<script>


export default {
    name: "navbar",
    data() {
        return {
            isInStep: '',
        }
    },
    mounted() {

    },
    methods: {
        login() {
            this.$auth.loginWithRedirect();
        },
        logout() {
            this.$auth.logout({
                returnTo: window.location.origin
            });
        }
    }
};
</script>

<style scoped>
.navbar {
    height: 10vh;
    width: 100vw;
    background-color: #000000;
}

.cc {
    width: 100%;
}
.nav-btn {
    padding: 10px;
    border-radius: 10px;
    border: none;
    background: none;
    color: white;
    font-size: 25px;
    font-family: system-ui;
    font-weight: bold;
}.nav-btn:hover {
    cursor: pointer;
    transition-duration: 0.4s;
    color: #818181;
}

.elements {
    width: 200px;
}

#nav-profilpic {
    border-radius: 50px;
    border: 2px solid white;
}


</style>