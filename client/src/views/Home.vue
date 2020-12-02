<template>
  <v-app>
    <my-header />
    <v-main class="pt-0">
      <v-container class="pa-15" fill-height>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import Header from "@/components/common/Header";

export default {
  name: "Home",
  components: {
    "my-header": Header,
  },
};
</script>

<style lang="scss">
.menu-nav {
  top: 64px !important;
  box-shadow: none !important;
  border-right: none !important;
}
.header {
  left: 0px !important;
}
</style>
