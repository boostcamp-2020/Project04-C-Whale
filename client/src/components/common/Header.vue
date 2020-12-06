<template>
  <v-container>
    <v-navigation-drawer class="left-menu px-4 py-4 grey lighten-5" v-model="drawer" app>
      <left-menu></left-menu>
    </v-navigation-drawer>
    <v-app-bar class="header whaleGreen" flat app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>할고래DO</v-toolbar-title>
      <search-bar></search-bar>
      <v-btn>
        <span @click="logout">로그아웃</span>
      </v-btn>
    </v-app-bar>
  </v-container>
</template>

<script>
import Search from "@/components/task/Search";
import LeftMenu from "@/components/menu/LeftMenu";
import { mapActions } from "vuex";

export default {
  data: () => ({ drawer: null }),
  components: {
    "search-bar": Search,
    LeftMenu,
  },
  methods: {
    ...mapActions(["logout"]),
  },
};
</script>

<style lang="scss">
.header {
  left: 0px !important;
}
.left-menu {
  top: 64px !important;
  box-shadow: none !important;
  border: 0px none !important;
}
$navigation-drawer-border-width: 0px;
</style>
