<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <div class="d-flex align-center">
        <router-link to="/login">Login</router-link>
        <router-link to="/today">Today</router-link>
      </div>
      <v-spacer></v-spacer>
      <router-link to="project/1">Project</router-link>
    </v-app-bar>
    <v-main>
      <router-view></router-view>
    </v-main>
  </v-app>
</template>

<script>
import router from "@/router/index.js";

export default {
  name: "App",
  data: () => ({
    //
  }),
  created: () => {
    router.push("/login");
  },
};
</script>
