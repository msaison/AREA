<template>
  <div class="profile">
    <div class="profilCard-container">
		<div id="edit-btn">
			<button class="edit-el" @click="isEditing = !isEditing" v-if="isEditing">Edit profil</button>
			<button class="edit-el" @click="isEditing = !isEditing" v-else>Finish editing</button>
		</div>
		<img class="profil-pic" :src="$auth.user.picture">
		<h2 v-if="isEditing" id="username">{{ $auth.user.name }}</h2>
		<div v-else>
			<div class="input-container">
				<input type="text" id="newName" @input="changeName" name="changeName" required minlength="1" maxlength="20" placeholder="New name">
			</div>
		</div>
		<p>{{ $auth.user.email }}</p>
		<div class="logout-container">
			<div id="btnlogout" @click="logout">Log out</div>
		</div>
    </div>
  </div>
</template>

<script>

// const axios = require('axios').default;

export default {
	name: "profile",
	data() {
		return {
			userProfil: [],
			isEditing: true,
		}
	},
	mounted() {
		this.userProfil = [
			{name: this.$auth.given_name},
		];
	},
	methods: {
		logout() {
			this.$auth.logout({
				returnTo: window.location.origin
			});
		},
		changeName() {
			this.$auth.user.name = document.getElementById('newName').value;
		}
	},
	propbs: {
		
	},
};
</script>

<style scoped>

* {
	font-family: system-ui;
}

.profile {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100vw;
    height: 90vh;
	background-color: #ececec;
}
.profilCard-container {
    height: 70%;
	width: 70%;
    background-color: #ffffff;
    border-radius: 20px;
}
.profil-pic {
    border-radius: 100px;
    height: 150px;
    width: 150px;
    margin: 30px;
    border: 2px solid #ffffff;
    box-shadow: 0px 0px 20px rgb(255, 255, 255);
}

#username {
	font-size: 50px;
}

.logout-container {
	display: flex;
    justify-content: center;
    align-items: center;
}

#btnlogout {
	cursor: pointer;
	font-size: 25px;
	border: 2px solid black;
	background-color: #ffffff;
	margin: 20px;
	padding: 10px 30px;
	border-radius: 100px;
}#btnlogout:hover {
	transition-duration: 0.4s;
	background-color: #e6e6e6;
}

/* #userId-container {
	width: 100%;
	border-radius: 20px;
}

#userId {
	font-family: system-ui;
	font-size: 20px;
	font-weight: bold;
} */




.edit-el {
	border: 3px solid black;
	background-color: white;
	font-size: 20px;
	font-weight: bold;
	padding: 20px;
	border-radius: 20px;

}
#edit-el:hover {
	cursor: pointer;
	text-decoration: underline;
}

#edit-btn {
	text-decoration: none;
	display: flex;
	justify-content: right;
	align-items: center;
	padding: 10px 20px;
}

.input-container {
	display: flex;
	justify-content: center;
	align-items: center;
}

#newName {
	border: 1px solid #e7e7e7;
	border-radius: 20px;
	padding: 10px;
	width: 200px;
}

</style>