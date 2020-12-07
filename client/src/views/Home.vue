<template>
  <v-app>
    <my-header />
    <v-main>
      <div class="router-view-container">
        <router-view></router-view>
      </div>
    </v-main>
  </v-app>
</template>

<script>
import Header from "@/components/common/Header";

export default {
  name: "Home",
  components: {
    "my-header": Header,
  },
};
</script>

<style>
.router-view-container {
  padding: 10px 20%;
  display: flex;
  justify-content: center;
}
</style>
