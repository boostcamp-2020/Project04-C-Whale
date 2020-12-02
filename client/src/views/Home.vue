<template>
  <v-app>
    <my-header />
    <!-- Sizes your content based upon application components -->
    <v-main class="pt-0">
      <!-- Provides the application the proper gutter -->
      <v-container class="pa-15" fill-height>
        <!-- If using vue-router -->
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import Header from "../components/common/Header";

export default {
  name: "Home",
  components: {
    "my-header": Header,
  },
};
</script>
