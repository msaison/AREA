<template>
    <div class="searchbar-comp">
		<div class="searchbar-container">
			<div class="searchbar">
				<div class=" icon-searchbar">
					<img src="https://icon-library.com/images/search-bar-icon-png/search-bar-icon-png-1.jpg" alt="LOGO" width="20px" height="20px">
				</div>
				<div class="input-searchbar">
					<input type="text" id="searchbar" @input="search_service" name="search" required minlength="1" maxlength="20" :placeholder="placeHolder">
				</div>
			</div>
		</div>
    </div>
</template>

<script>

export default {
    name: 'searchbar',
    data() {
        return {

        }
    },
    mounted() {

    },
    methods: {
        search_service: function () {
            let input = document.getElementById('searchbar').value
            input=input.toLowerCase();
            let x = document.getElementsByClassName('gridElement');
            
            for (let i = 0; i < x.length; i++) { 
                if (!x[i].innerHTML.toLowerCase().includes(input)) {
                    x[i].style.display="none";
                }
                else {
                    x[i].style.display="list-item";
                }
            }
        },
    },
    props: [
        'placeHolder'
    ]
    
}
</script>

<style scoped>

.searchbar-comp {
    width: 100vw;
    height: 10vh;
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
	border: 5px solid #f0f0f0;
	border-radius: 10px;
}

.icon-searchbar{
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

input[type=text], select {
	height: 90%;
	width: 100%;
	border-radius: 10px;
	border: none;
	font-size: 30px;
}
</style>
