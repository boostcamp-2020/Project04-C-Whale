<template>
  <v-container>
    <v-navigation-drawer v-model="drawer" app>
      <left-menu class="menu-nav"></left-menu>
    </v-navigation-drawer>
    <v-app-bar app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>할고래DO</v-toolbar-title>
      <serach-bar />
      <v-btn flat>
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
    "serach-bar": Search,
    LeftMenu,
  },
  methods: {
    ...mapActions(["logout"]),
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
