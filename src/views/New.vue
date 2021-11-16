<template lang="html">


  <div class="home">
    <button class ="sbutton" @click = "goToSignIn"> Sign In</button>
    <button class= "sbutton" @click = "goToSignIn"> Sign Up</button>
    
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'


export default defineComponent({

  name: 'New',
  methods: {
    goToSignIn() {
      this.$router.push({ name: 'NewAccount' })
    },
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 50%;
  
  margin: auto;
}


.sbutton {
  background-color: #0423aa;
  color: white;
  padding: 14px 20px;
  margin: 20px 0;
  border: none;
  cursor: pointer;
  height: 100%;
  width: 100%;
  opacity: 0.9;
}

</style>
