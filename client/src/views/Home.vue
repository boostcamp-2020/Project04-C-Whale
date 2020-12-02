<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app />
    <v-app-bar app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>

      <v-toolbar-title>할고래DO</v-toolbar-title>
    </v-app-bar>
    <v-main>
      <div class="router-view-container">
        <router-view></router-view>
      </div>
    </v-main>
  </v-app>
</template>

<script>
// import Menu from "../components/menu";

export default {
  name: "Home",
  components: {
    // Menu,
  },
  data: () => ({ drawer: false }),
};
</script>

<style>
.router-view-container {
  padding: 50px 20%;
  display: flex;
  justify-content: center;
}
</style>
