<template>
  <v-app>
    <v-navigation-drawer class="menu-nav grey lighten-4" hide-overlay flat v-model="drawer" app>
      <left-menu></left-menu>
    </v-navigation-drawer>
    <v-app-bar flat app class="header whaleGreen">
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>할고래DO</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn>
        <span @click="logout">로그아웃</span>
      </v-btn>
    </v-app-bar>
    <!-- Sizes your content based upon application components -->
    <v-main>
      <!-- Provides the application the proper gutter -->
      <v-container class="pa-15" fill-height>
        <!-- If using vue-router -->
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import { mapActions } from "vuex";
import LeftMenu from "@/components/menu/LeftMenu.vue";
export default {
  name: "Home",
  components: {
    "left-menu": LeftMenu,
  },
  data: () => ({ drawer: null }),
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

$navigation-drawer-border-width: 0px;
</style>
