<template>
  <v-app>
    <v-navigation-drawer app> menuNav </v-navigation-drawer>
    <v-app-bar app> Header </v-app-bar>
    <!-- Sizes your content based upon application components -->
    <v-main>
      <!-- Provides the application the proper gutter -->
      <v-container fluid fill-height>
        <!-- If using vue-router -->
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
// @ is an alias to /src
export default {
  name: "Home",
};
</script>
