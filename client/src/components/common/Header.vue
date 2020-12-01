<template>
  <v-container>
    <v-navigation-drawer v-model="drawer" app>
      <!-- <Menu /> -->
    </v-navigation-drawer>
    <v-app-bar app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>할고래DO</v-toolbar-title>
      <serach-bar />
    </v-app-bar>
  </v-container>
</template>

<script>
import Search from "../task/Search";
export default {
  name: "Header",
  data: () => ({ drawer: null }),
  components: {
    "serach-bar": Search,
  },
};
</script>
