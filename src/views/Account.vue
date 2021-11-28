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
        <p><b>Balance: </b>{{ account.balance }} BC Tokens</p>
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
        <p><b>Balance: </b>{{ orgAccount.balance }} BC Tokens</p>
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
    <card
      v-for="(project, index) in projects"
      v-bind:key="project.name"
      :title="project.name"
      :blue="true"
    >
      <div
        class="container"
        
      >
        
        <p><b>Owner: </b><span :id="'sp_' + index">{{ getName(project.owner,'sp_' + index) }}</span></p>
        <div>
          <p><b>Balance of Project: </b>{{ project.balance }} BC Tokens</p>
          <h2>Contributors:</h2>
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
          
        
        

        <div class="container" v-if="showAddContributor">
          <form id="signup-form" style="border:1px solid #ccc" @submit.prevent="addContributor('in_' + index, index)">
            <div class="container">
              <label for="name"><b>Paste Contributor Address and Hit Enter</b></label>
              <input type="text" :id="'in_' + index" placeholder="Contributor Address" name="name" required>

            </div>
          </form>
        </div>

        <button @click="flipContributor">Add a Member</button>


        <div v-if="getBugsById(project.bugId)">
          <h2>Bugs: </h2>
          <div class="container" style="border:1px solid #ccc" v-for="bugg in getBugsById(project.bugId)"
            v-bind:key="bugg.title"
          >
            <p style="padding-left: 10px">Title: {{ bugg.title }}</p>
            <p style="padding-left: 10px">Description: {{ bugg.description }}</p>
            <p style="padding-left: 10px">Bounty: {{ bugg.reward }}</p>
            <h3 v-if="bugg.proposals.length>0" style="padding-left: 10px">Proposals:</h3>
                <div class="container"  style="border:1px solid #ccc;margin-left: 20px" v-for="(ppsl, indexf) in bugg.proposals"
                v-bind:key="ppsl"
                >

                  <p style="padding-left: 10px">{{ ppsl }}</p>
                  <button v-if="!bugg.resolved" @click="acceptFix(bugg, bugg.proposers[indexf])">Accept Fix</button>
                  
                </div>
            <div class="container" style="padding-left: 10px;background-color: green" v-if="bugg.resolved">
            <p >Resolved with:</p>
            <p >{{ bugg.fix }}</p>
            </div>
          </div>
        </div>

        
      <div class="container" v-if="showAddBugs">
          <form id="signup-form" style="border:1px solid #ccc" @submit.prevent="addBug('inbt_' + index, 'inbd_' + index, 'inbr_' + index, project.bugid)">
            <div class="container">
              <label for="title"><b>Title</b></label>
              <input type="text" :id="'inbt_' + index" placeholder="Title" name="name" required>

              <label for="descrip"><b>Description</b></label>
              <input type="text" :id="'inbd_' + index" placeholder="Discription" name="name" required>

              <label for="reward"><b>Bounty</b></label>
              <input type="number" min="1" :id="'inbr_' + index" placeholder="Bounty" name="reward" required>
              <button @click="addBug('inbt_' + index, 'inbd_' + index, 'inbr_' + index, project.bugId)">Add</button>
            </div>
          </form>
        </div>
        <button @click="flipAddBugs">Add a Bug</button>

        


      </div>
      
      </card>
      
      <card>
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
                v-bind:nom="getName(member, 'tgmaaaa_' + index)"
              >

                    <div  @click="openProfile(member)" style="cursor: pointer">
                    <p
                    :id="'tgmaaaa_' + index"
                    style="padding-left: 10px"
                    >
                    
                    {{ nom }}
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
                        <p ><b>Owner: </b> <span id='mamaz'>{{ getName(selectedOrgAccount.owner,'mamaz') }}</span></p>
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
  
                        <div v-if="sorgrefs.length>0">
                          <h2>Associated Organisations: </h2>
                          <div class="container" style="border:1px solid #ccc" v-for="(org, index) in sorgrefs"
                            v-bind:key="org.name"
                          >
                            <p style="padding-left: 10px">Name: {{ org.name }}</p>
                            <p style="padding-left: 10px">Owner: <span :id="'oref_' + index" >  {{getName(org.owner,'oref_' + index) }}</span></p>
                            <p style="padding-left: 10px">Owner Adress: {{ org.owner }}</p>
                          </div>
                        </div>                        
  
  
                      </div>

                      
                    </card>
  
      
        
                     <spacer :size="24" />
  
  
  
  
  


            <card title="Projects" v-if="selectedProjects"  >

              <div class="explanations" v-for="(project, index) in selectedProjects"
                v-bind:key="project.name"
              >
                <h2>{{ project.name }}</h2>
                <p><b>Owner: </b><span :id="'sp_' + index">{{ getName(selectedOrgAccount.owner,'sp_' + index) }}</span></p>
                <p><b>Balance of Project: </b>{{ project.balance }} BC Tokens</p>
                <div>
                  <h2>Contributors:</h2>
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


        <div v-if="getBugsById2(project.bugId).length>0">
          <h2>Bugs: </h2>
          <div class="container" style="border:1px solid #ccc" v-for="(bugg,indexb) in getBugsById2(project.bugId)"
            v-bind:key="bugg.title"
            
          >
            
            <p style="padding-left: 10px">Title: {{ bugg.title }}</p>
            <p style="padding-left: 10px">Description: {{ bugg.description }}</p>
            <p style="padding-left: 10px">Bounty: {{ bugg.reward }}</p>
            
            <h3 v-if="bugg.proposals.length>0" style="padding-left: 10px">Proposals:</h3>
                <div class="container"  style="border:1px solid #ccc;margin-left: 20px" v-for="ppsl in bugg.proposals"
                v-bind:key="ppsl"
                >

                  <p style="padding-left: 10px">{{ ppsl }}</p>
                  
                  
                </div>
            <label for="addfix"><b>Propose a Fix</b></label>
            <input type="text" :id="'inbfffxyz_' + index+''+indexb" placeholder="Fix" name="name" required>

            <button @click="addFix2(bugg, project.owner, 'inbfffxyz_' + index+''+indexb)">Propose Fix</button>
            
          </div>
        </div>





                </div>
                  
              
                

                <div class="container" v-if="showDonation">
                  <form id="donation-signup-form" style="border:1px solid #ccc" @submit.prevent="donateToken(selectedAddress, index)">
                    <div class="container">
                      <label for="tokens"><b>Token Donation</b></label>
                      <input type="number" v-model="donationAmount" placeholder="input Token amount to give" name="tokens" required>

                    </div>
                  </form>
                </div>


              </div>

                <button @click="flipDonation">Donate</button>


                
                
                <div v-if="sprojectrefs.length>0">
                  <h2>Associated Projects: </h2>
                  <div class="container" style="border:1px solid #ccc" v-for="(proj, index) in sprojectrefs"
                    v-bind:key="proj.name"
                  >
                    <p style="padding-left: 10px">Name: {{ proj.name }}</p>
                    <p style="padding-left: 10px">Owner: <span :id="'prref_' + index" >  {{getName(proj.owner,'prref_' + index) }}</span></p>
                    <p style="padding-left: 10px">Owner Adress: {{ proj.owner }}</p>
                  </div>
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
    const bugs: any[] = [];
    const showAddBugs = false;
    const sorgrefs: any[] = []
    const sprojectrefs: any[] = []
    const sbugs: any[] = []
    const donationAmount = 0
    const showDonation = false;
    

    return {account, username, mbalance, orgAccount,
     projects, showAddMember, showAddContributor, memadrs, memcon,
     tabList: ["Account", "Explore"],
     allusers, membalance, showAddBalance, orgrefs, projectrefs,
     selectedProfile, selectedAddress, selectedOrgAccount, selectedProjects, showAllUsers,
     bugs, showAddBugs, sorgrefs, sprojectrefs, donationAmount, showDonation ,sbugs
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
     const { contract, address } = this
      this.allusers = await contract.methods.getAllUsers().call()
        .filter((str:string) => !(str.toLowerCase() === address.toLowerCase()))   
    },
    async updateBugs() {
      const { contract, address } = this
      this.bugs = await contract.methods.getBugs(address).call()
    
    },
    async updateOrgAccount() {
      const { address, contract } = this
      this.orgAccount = await contract.methods
        .getOrg(address)
        .call()
        
    },
    async updateProjects() {
      const { address, contract } = this
      this.projects = await contract.methods
        .getProject(address)
        .call()
      
    },
    flipMember() {
      this.showAddMember = !this.showAddMember;
    },
    flipAddBugs() {
     
      
      this.showAddBugs = !this.showAddBugs;
    },
    flipBalance() {
      this.showAddBalance = !this.showAddBalance;
     
    },
    flipContributor() {
      this.showAddContributor = !this.showAddContributor;
      
    },
    flipAllUsers() {
      this.showAllUsers = !this.showAllUsers;
    },
    flipDonation(){
      this.showDonation = !this.showDonation
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
    async donateToken(owner:string, index:any){
      const { contract, address } = this
      const value = this.donationAmount
      if(value > contract.methods.getUser(owner).call().balance){
        alert("Not enough tokens!")
      }else{
         await contract.methods.donateProject(owner, index, value).send()
      }
      this.showDonation = false

      await this.updateAccount()
      await this.openProfile(owner)

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
    async addBug(idd1:any, idd2:any, idd3:any, bugid:any) {
      const { contract } = this
      
      const title = document.getElementById(idd1) as HTMLInputElement;
      const desc = document.getElementById(idd2) as HTMLInputElement;
      const bounty = document.getElementById(idd3) as HTMLInputElement;
      await contract.methods.addBug(bugid, title.value, desc.value, bounty.value).send()
      
      this.showAddBugs = false
      await this.updateBugs()
      await this.updateAccount()
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
      this.sbugs = await contract.methods.getBugs(adr).call()
      this.showAllUsers = false;
    },
    hoo(){  
      const {allusers } = this;
      this.allusers = allusers;
      
    },
    getBugsById(projid:any){  
      const lst = [];
      var idx = 0
      for (idx = 0; idx < this.bugs.length; idx++) {
          if(this.bugs[idx].projId === projid) lst.push(this.bugs[idx])
      }
      return lst
    },
    getBugsById2(projid:any){  
      const lst = [];
      var idx = 0
      for (idx = 0; idx < this.sbugs.length; idx++) {
          if(this.sbugs[idx].projId === projid && !this.sbugs[idx].resolved) lst.push(this.sbugs[idx])
      }
      return lst
    },
    async addFix(b:any, owner:any, idd:any){  
      const { contract } = this
      const val = document.getElementById(idd) as HTMLInputElement;
      
      await contract.methods.proposeFix(owner, this.bugs.indexOf(b), val.value).send()
      
      val.value = ''
     
      await this.updateBugs()
      await this.updateAccount()
      await this.updateProjects()
    },
    async addFix2(b:any, owner:any, idd:any){  
      const { contract } = this
      const val = document.getElementById(idd) as HTMLInputElement;
      
      await contract.methods.proposeFix(owner, this.sbugs.indexOf(b), val.value).send()
      
      val.value = ''
     
      await this.updateBugs()
      await this.updateAccount()
      await this.updateProjects()
    },

    async acceptFix(b:any, proposer:any){  
      const { contract } = this
      
      
      await contract.methods.acceptFix(this.bugs.indexOf(b), proposer).send()
      
     
      await this.updateBugs()
      await this.updateAccount()
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

    if (orgAccount.name) this.orgAccount = orgAccount
    const projects = await contract.methods.getProject(address).call()
    if (projects.length > 0) this.projects = projects
    const allusers = await contract.methods.getAllUsers().call()
    const allusers2 = allusers.filter((str:string) => !(str.toLowerCase() === address.toLowerCase()))
    if (allusers2.length > 0) this.allusers = allusers2
    const orgrefs = await contract.methods.getOrgRefs(address).call()
    const projectrefs = await contract.methods.getProjectRefs(address).call()
    if (orgrefs.length > 0) this.orgrefs = orgrefs
    if (projectrefs.length > 0) this.projectrefs = projectrefs
    const bugs = await contract.methods.getBugs(address).call()
    if (bugs.length > 0) this.bugs = bugs
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


.cancelbtn {
  padding: 14px 20px;
  background-color: #f44336;
}


.cancelbtn, .signupbtn {
  float: left;
  width: 50%;
}


.container {
  padding: 16px;
}


.clearfix::after {
  content: "";
  clear: both;
  display: table;
}


@media screen and (max-width: 300px) {
  .cancelbtn, .signupbtn {
    width: 100%;
  }
}

.tabiiies{
  width: 900px;
}
</style>
