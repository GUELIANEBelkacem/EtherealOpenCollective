<template>


  <div
    :class="{
      flex: variant === 'horizontal',
    }"
   
  >
    <ul
      :class="{
        flex: variant === 'vertical',
      }"
    >


    <div class="containerTab2">
      <li v-for="(tab, index) in tabList" :key="index">
        <div class="containerTab" :style="`background-color:${(activeTab === index+1)?'#35068c':'#5920c3'}`">
        <label :for="`${_uid}${index}`" v-text="tab" />
        <input
          :id="`${_uid}${index}`"
          type="radio"
          :name="`${_uid}-tab`"
          :value="index + 1"
          v-model="activeTab"
        />
        </div>
      </li>
      </div>
    </ul>

    <template v-for="(tab, index) in tabList" class="taboo" >
      <div :key="index" v-if="index + 1 === activeTab">
        <slot :name="`tabPanel-${index + 1}`"/>
      </div>
    </template>
  </div>
  
</template>

<script>
export default {
  name: 'AppTabs',
  props: {
    tabList: {
      type: Array,
      required: true,
    },

    variant: {
      type: String,
      required: false,
      default: () => "vertical",
      validator: (value) => ["horizontal", "vertical"].includes(value),
    },
  },

  data() {
    return {
      activeTab: 1,
    };
  },
};
</script>

<style>
.flex {
  display: flex;
}
.containerTab {
  padding: 16px;
  background-color: #5920c3;
  display: flex;
  flex-direction: row;
  width: 100%;
  border-radius: 10px;
  justify-content: center;
  align-content: center;
  align-items:center;
  text-align: center;
}
.containerTab2 {
  gap: 50px 2px;
  display: flex;
  flex-direction: row;
  width: 100%;
 

}

ul {
  list-style-type: none;
 
 }

ul, li {
    list-style: none;
    margin: 0;
    padding: 0;
}
ul {
    width: 100%;
}
li {
    float: left;
    width: 50%;
}
li:hover {
    background-color: #DEDEDE;
}


</style>