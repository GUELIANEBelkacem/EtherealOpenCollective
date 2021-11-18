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
        <div class="containerTab">
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

    <template v-for="(tab, index) in tabList">
      <div :key="index" v-if="index + 1 === activeTab">
        <slot :name="`tabPanel-${index + 1}`" />
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
}
.containerTab2 {
  gap: 50px 20px;
  display: flex;
  flex-direction: row;
}

ul {
  list-style-type: none;
 }
</style>