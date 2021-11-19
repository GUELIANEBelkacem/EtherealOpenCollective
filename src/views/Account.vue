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
    <div class="welcomecard">
    <card title="Welcome!!!"></card>
    </div>
    <div class = "tabs">



    <app-tabs :tabList="tabList" >
      <template v-slot:tabPanel-1 class="tabiiies"> 




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

        <div class="container" v-if="showAddBalance">
          <form id="signup-form" style="border:1px solid #ccc" @submit.prevent="addBalance">
            <div class="container">
              <label for="name"><b>Add Some Tokens and Hit Enter</b></label>
              <input type="number" min="1"  v-model="membalance" placeholder="Tokens" name="name" required>

            </div>
          </form>
        </div>
      </div>
      <button @click="flipBalance">Add to the Balance</button>
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


        <div v-if="orgrefs.length>0">
          <h2>Associated Organisations: </h2>
          <div class="container" style="border:1px solid #ccc" v-for="(org, index) in orgrefs"
            v-bind:key="org.name"
          >
            <p style="padding-left: 10px">Name: {{ org.name }}</p>
            <p style="padding-left: 10px">Owner: <span :id="'oref_' + index" >  {{getName(org.owner,'oref_' + index) }}</span></p>
            <p style="padding-left: 10px">Owner Adress: {{ org.owner }}</p>
          </div>
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

        <div v-if="projectrefs.length>0">
          <h2>Associated Projects: </h2>
          <div class="container" style="border:1px solid #ccc" v-for="(proj, index) in projectrefs"
            v-bind:key="proj.name"
          >
            <p style="padding-left: 10px">Name: {{ proj.name }}</p>
            <p style="padding-left: 10px">Owner: <span :id="'prref_' + index" >  {{getName(proj.owner,'prref_' + index) }}</span></p>
            <p style="padding-left: 10px">Owner Adress: {{ proj.owner }}</p>
          </div>
        </div>
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

    



  </template>














  <template v-slot:tabPanel-2 class="tabiiies">














  
      <div @click="flipAllUsers" style="cursor: pointer">
        <card
          title="All Users"
          subtitle=""
        >
        </card>
      </div>
      <card
        title=""
        subtitle=""
      >
      
        <div class="explanations" v-if="showAllUsers">
          
          










            
            
  
              <div class="container" style="border:1px solid #ccc"
                
                v-for="(member, index) in allusers"
                v-bind:key="member"
              >

                    <div @click="openProfile(member)" style="cursor: pointer">
                    <p
                    :id="'tgmaaaa_' + index"
                    style="padding-left: 10px"
                    >
                    
                    {{ getName(member, 'tgmaaaa_' + index) }}
                    </p>
                    <p><b> Address:  </b>{{ member }}</p>
    
                    </div>
              </div>
              
        </div>

      </card>





              <div class="mywrapper" v-if="selectedProfile" @click="hoo">














                


                  <spacer :size="24" />
  
  
                    <card 
                      title="Account"
                      subtitle=""
                      :gradient="true"
                    >
                      <div class="explanations">
                        <h2><b>{{ selectedProfile.username }}</b></h2>
                        
                        <p><b>Address: </b>{{ selectedAddress }}</p>
                      </div>
                    </card>
  
  
  
  
                    <spacer :size="24" />
  
  
  
  
  
  
  
  
                    <card
                      title="Organisation"
                      subtitle=""
                      v-if="selectedOrgAccount"
                    >
                      <div class="explanations" >
                        <h2>{{selectedOrgAccount.name}}</h2>
                        <p ><b>Owner: </b> <span id='mama'>{{ getName(selectedOrgAccount.owner,'mama') }}</span></p>
                        <p><b>Owner's Address: </b>{{ selectedAddress }}</p>
                        
                        <div>
                          <b>Members: </b>
  
                          <div class="container" style="border:1px solid #ccc"
                            
                            v-for="(member, index) in selectedOrgAccount.members"
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
  
                        
  
  
                      </div>

                      
                    </card>
  
      
        
                     <spacer :size="24" />
  
  
  
  
  
  
  
                    <card
                      title="Projects"
                      v-if="selectedProjects"
                    >




                      <div
                        class="explanations"
                        v-for="(project, index) in selectedProjects"
                        v-bind:key="project.name"
                      >
                        <h2>{{ project.name }}</h2>
                        <p><b>Owner: </b><span :id="'sp_' + index">{{ getName(selectedOrgAccount.owner,'sp_' + index) }}</span></p>
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
  
                        </div>
  
                    </card>







                </div>
  
        
  










      
          
          
        






     
  
  
  
  
  
  
  

  </template>
  </app-tabs>
    
  </div>
  </div>
  

</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import AppTabs from "../components/AppTabs.vue";

export default defineComponent({
  components: { Card, AppTabs },
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
    const showAddBalance = false;
    const memadrs = ''
    const memcon = ''
    const membalance = 1
    const allusers: any[] = []
    const orgrefs: any[] = []
    const projectrefs: any[] = []
    const selectedProfile = null;
    const selectedAddress = "";
    const selectedOrgAccount = null;
    const selectedProjects: any[] = [];
    const showAllUsers = true;
    

    return {account, username, mbalance, orgAccount,
     projects, showAddMember, showAddContributor, memadrs, memcon,
     tabList: ["Account", "Explore"],
     allusers, membalance, showAddBalance, orgrefs, projectrefs,
     selectedProfile, selectedAddress, selectedOrgAccount, selectedProjects, showAllUsers
     }
  },
  methods: {
    goBack() {
      this.$router.push({ name: 'SignIn' })
    },
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
      this.updateAllUsers() 
    
    },
    async updateAllUsers() {
      const { contract } = this
      this.allusers = await contract.methods.getAllUsers().call()
    
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
    flipBalance() {
      this.showAddBalance = !this.showAddBalance;
      console.log("refs")
      console.log(this.orgrefs)
      console.log(this.projectrefs)
    },
    flipContributor() {
      this.showAddContributor = !this.showAddContributor;
      console.log(this.orgrefs)
      console.log(this.projectrefs)
    },
    flipAllUsers() {
      this.showAllUsers = !this.showAllUsers;
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
    async addBalance() {
      const { contract } = this
      const tok = (this.membalance && this.membalance>0)? this.membalance:0;
      await contract.methods.addBalance(tok).send()
      this.membalance = 1 
      this.showAddBalance = false
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
    async openProfile(adr:any){
      const { contract } = this
      this.selectedAddress = adr
      this.selectedOrgAccount = await contract.methods
        .getOrg(adr)
        .call()
      this.selectedProjects = await contract.methods.getProject(adr).call()
      this.selectedProfile = await contract.methods.getUser(adr).call()
      this.showAllUsers = false;
    },
    hoo(){  
      const {allusers } = this;
      this.allusers = allusers;
      console.log("fuuuuuuuuuuuuuuck")
      console.log(this.allusers)
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
    const allusers = await contract.methods.getAllUsers().call()
    if (allusers.length > 0) this.allusers = allusers
    const orgrefs = await contract.methods.getOrgRefs(address).call()
    const projectrefs = await contract.methods.getProjectRefs(address).call()
    if (orgrefs.length > 0) this.orgrefs = orgrefs
    if (projectrefs.length > 0) this.projectrefs = projectrefs
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: row;
  justify-content: center;
  width: 100%;
  max-width: 500px;
  margin: auto;
  align-items: center;
  align-self: center;
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
  align-content: center;
  gap: 10px;
  align-self: center;
  display: flex;
  flex-direction: column;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.tabs {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 80%;
  align-content: center;
  gap: 10px;
  align-self: center;
  display: flex;
  flex-direction: column;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.welcomecard{
  text-align: center;
  align-self: center;
  width: 80%;
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

.tabiiies{
  width: 900px;
}
</style>
