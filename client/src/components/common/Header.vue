<template>
  <v-app-bar app color="primary" dark>
    <div class="d-flex align-center">
      <router-link to="/login">Login</router-link>
      <router-link to="/today">Today</router-link>
    </div>
    <v-spacer></v-spacer>
    <router-link to="project/1">Project</router-link>
  </v-app-bar>
</template>

<script>
export default {
  name: "Header",
};
</script>
