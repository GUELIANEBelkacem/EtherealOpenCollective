<template lang="html">


  <div class="home">
   <form id="signup-form" style="border:1px solid #ccc">
      <div class="container">
        <h1>Create an Organisation</h1>
        <p>Please fill in this form to create an Organisation Account</p>
        <hr>

        <label for="name"><b>Name</b></label>
        <input type="text" v-model="oname" placeholder="Organisation Name" name="name" required>

        <label for="balance"><b>Balance</b></label>
        <input type="number" v-model="mbalance" min=0 placeholder="Initial Balance" name="balance">


        <div class="clearfix">
          <button type="button" class="cancelbtn" @click="goBack" >Cancel</button>
          <button type="button" class="signupbtn" @click="submit" >Sign Up</button>
        </div>
      </div>
    </form>
  </div>


</template>

<script lang="ts">
import { defineComponent, computed} from 'vue'
import { useStore } from 'vuex'


export default defineComponent({

  name: 'NewOrg',
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return {contract, address}
  },
  data() {
    const oname = ''
    const mbalance = 0
    const members: any[] = []
    return {oname, mbalance, members};
  },
  methods: {
    goBack() {
      this.$router.push({ name: 'Account' })
    },
    /*
    async updateEnterpriseAccount() {
      const { contract, address  } = this
      this.enterpriseAccount = await contract.methods
        .getEnterpriseByAddress(address)
        .call()
    },
    */
    async submit(){
      const { contract, address} = this
      console.log(address)
      const ooname = this.oname.trim().replace(/ /g, '_')
      const mmbalance = (!this.mbalance)? 0 : this.mbalance;

      this.members.push(address)
      await contract.methods.orgSignUp(ooname, address, this.members, mmbalance).send()
    
      await this.$router.push({ name: 'Account' })
     
        
      
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


* {box-sizing: border-box}

/* Full-width input fields */
  input[type=text], input[type=number] {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  display: inline-block;
  border: none;
  background: #f1f1f1;
}

input[type=text]:focus, input[type=password]:focus {
  background-color: #ddd;
  outline: none;
}

hr {
  border: 1px solid #f1f1f1;
  margin-bottom: 25px;
}

/* Set a style for all buttons */
button {
  background-color: #04AA6D;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  cursor: pointer;
  width: 100%;
  opacity: 0.9;
}

button:hover {
  opacity:1;
}

/* Extra styles for the cancel button */
.cancelbtn {
  padding: 14px 20px;
  background-color: #f44336;
}

/* Float cancel and signup buttons and add an equal width */
.cancelbtn, .signupbtn {
  float: left;
  width: 50%;
}

/* Add padding to container elements */
.container {
  padding: 16px;
}

/* Clear floats */
.clearfix::after {
  content: "";
  clear: both;
  display: table;
}

/* Change styles for cancel button and signup button on extra small screens */
@media screen and (max-width: 300px) {
  .cancelbtn, .signupbtn {
    width: 100%;
  }
}

</style>
