<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <!-- <Menu /> -->
    </v-navigation-drawer>
    <v-app-bar flat app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>할고래DO</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn flat>
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

export default {
  name: "Home",
  components: {
    // Menu,
  },
  data: () => ({ drawer: null }),
  methods: {
    ...mapActions(["logout"]),
  },
};
</script>
