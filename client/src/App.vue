<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <div class="d-flex align-center">
        <router-link to="/">Home</router-link>
        <router-link to="/about">About</router-link>
      </div>
      <v-spacer></v-spacer>
      <router-link to="/about/1">About 1</router-link>
    </v-app-bar>

    <v-main>
      <router-view></router-view>
    </v-main>
  </v-app>
</template>

<script>

export default {
  name: "App",

  data: () => ({
    //
  }),
};
</script>
