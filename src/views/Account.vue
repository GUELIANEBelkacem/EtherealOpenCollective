<template lang="html">




  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Sign Up for a free user account!!!"
        subtitle=""
      >
        <div class="container">
        <h1>Sign Up</h1>
        <p>Please fill in this form to create an account.</p>
        <hr>

        <label for="name"><b>Name</b></label>
        <input type="text" v-model="username" placeholder="Name" name="name" required>

        <label for="balance"><b>Balance</b></label>
        <input type="number" v-model="mbalance" min=0 placeholder="Initial Balance" name="balance" required>

        <div class="clearfix">
          <button type="button" class="cancelbtn" @click="goBack" >Cancel</button>
          <button type="submit" class="signupbtn" @click="signUp" >Sign Up</button>
        </div>
      </div>
      </card>
    </form>
  </div>








  <div class="mywrapper" v-if="account">
    <card title="Welcome!!!"></card>


    <spacer :size="24" />


    <card 
      title="Account"
      subtitle=""
      :gradient="true"
    >
      <div class="explanations">
        <h2><b>{{ account.username }}</b></h2>
        <p><b>Balance: </b>{{ account.balance }}</p>
        <p><b>Address: </b>{{ address }}</p>
        <p><b>ETH: </b>{{ balance }}</p>
      </div>
    </card>




    <spacer :size="24" />








    <card
      title="Organisation"
      subtitle=""
      v-if="orgAccount"
    >
      <div class="explanations" >
        <h2>{{orgAccount.name}}</h2>
        <p ><b>Owner: </b> <span id='mama'>{{ getName(orgAccount.owner,'mama') }}</span></p>
        <p><b>Owner's Address: </b>{{ address }}</p>
        <p><b>Balance: </b>{{ orgAccount.balance }} T</p>
        <div>
          <b>Members: </b>

          <div class="container" style="border:1px solid #ccc"
            
            v-for="(member, index) in orgAccount.members"
            v-bind:key="member"
          >
            
            <p
              :id="'tgm_' + index"
              style="padding-left: 10px"
            >

              {{ getName(member, 'tgm_' + index) }}
            </p>
            <p><b> Address:  </b>{{ member }}</p>
          </div>


    
        </div>

        <button @click="flipMember">Add a Member</button>


        <div class="container" v-if="showAddMember">
          <form id="signup-form" style="border:1px solid #ccc" @submit.prevent="addMember">
            <div class="container">
              <label for="name"><b>Paste Member Address and Hit Enter</b></label>
              <input type="text" v-model="memadrs" placeholder="Member Address" name="name" required>

            </div>
          </form>
        </div>


      </div>
    </card>

    <card
        title="Organisation"
        subtitle="Do you have a Company/Organisation?"
        :blue="false"
        v-if="!orgAccount"
      >
        <router-link class="card-body" to="/NewOrg">
           <p style="color:red;padding-left: 10px">Add Your Company/Organisation</p>
        </router-link>
    </card>
      
    <spacer :size="24" />







    <card
      title="Projects"
      v-if="projects.length >0"
    >
      <div
        class="explanations"
        v-for="(project, index) in projects"
        v-bind:key="project.name"
      >
        <h2>{{ project.name }}</h2>
        <p><b>Owner: </b><span :id="'sp_' + index">{{ getName(orgAccount.owner,'sp_' + index) }}</span></p>
        <div>
          <b>Contributors:</b>
          <div class="container" style="border:1px solid #ccc"
            
            v-for="(contributor, index2) in project.contributors"
            v-bind:key="contributor.address"
          >
            
            <p
              :id="'tgmm_' + index2+'_' + index"
              style="padding-left: 10px"
            >

              {{ getName(contributor, 'tgmm_' + index2+'_' + index) }}
            </p>
            <p><b> Address:  </b>{{ contributor }}</p>
          </div>


    
        </div>
          
      
        <p><b>Balance of Project: </b>{{ project.balance }} T</p>

        


        <div class="container" v-if="showAddContributor">
          <form id="signup-form" style="border:1px solid #ccc" @submit.prevent="addContributor('in_' + index, index)">
            <div class="container">
              <label for="name"><b>Paste Contributor Address and Hit Enter</b></label>
              <input type="text" :id="'in_' + index" placeholder="Contributor Address" name="name" required>

            </div>
          </form>
        </div>


      </div>
      <button @click="flipContributor">Add a Member</button>
    </card>


      <card
        title="Create a project"
        subtitle=""
        :blue="false"
      >
        <router-link class="card-body" to="/NewProject">
          <p style="color:red;padding-left: 10px">Create your project</p>
        </router-link>
      </card>
    
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const username = ''
    const mbalance = 0
    const orgAccount = null;
    const projects: any[] = [];
    const showAddMember = false;
    const showAddContributor = false;
    const memadrs = ''
    const memcon = ''

    return {account, username, mbalance, orgAccount,
     projects, showAddMember, showAddContributor, memadrs, memcon}
  },
  methods: {
    goBack() {
      this.$router.push({ name: 'SignIn' })
    },
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async updateOrgAccount() {
      const { address, contract } = this
      this.orgAccount = await contract.methods
        .getOrg(address)
        .call()
        console.log(this.orgAccount)
    },
    async updateProjects() {
      const { address, contract } = this
      this.projects = await contract.methods
        .getProject(address)
        .call()
      console.log(this.projects)
    },
    flipMember() {
      this.showAddMember = !this.showAddMember;
    },
    flipContributor() {
      this.showAddContributor = !this.showAddContributor;
    },
    async signUp() {
      
      const { contract, username, mbalance } = this
      const name = username.trim().replace(/ /g, '_')
      const mmbalance = (!mbalance)? 0 : mbalance;
      await contract.methods.signUp(name, mmbalance).send()
      await this.updateAccount()
      this.username = ''
      
     

    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
    async addMember() {
      const { contract } = this
      const adr = this.memadrs;
      await contract.methods.addMember(adr).send()
      this.memadrs = ''
      this.showAddMember = false
      await this.updateOrgAccount()
    },
    async addContributor(idd:any, idx:any) {
      const { contract } = this
      const adr = document.getElementById(idd) as HTMLInputElement;
      await contract.methods.addContributor(adr.value, idx).send()
      this.memcon = ''
      this.showAddContributor = false
      await this.updateProjects()
    },

    getName(adrs:any, idd:any){
        const {contract } = this;
        contract.methods.getUser(adrs).call()
          .then((res:any) =>{
              document.getElementById(idd)!.textContent = ""+res.username
          });
    }
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    if (account.registered) this.account = account
    const orgAccount = await contract.methods.getOrg(address).call()
    console.log(orgAccount)
    console.log(address)
    if (orgAccount.name) this.orgAccount = orgAccount
    const projects = await contract.methods.getProject(address).call()
    if (projects.length > 0) this.projects = projects
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
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}



.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.mywrapper {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}




















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
