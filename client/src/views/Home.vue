<template>
  <v-app>
    <my-header />
    <v-main>
      <div class="router-view-container">
        <keep-alive>
          <router-view :key="$route.params.projectId"></router-view>
        </keep-alive>
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
  padding: 50px 20%;
  display: flex;
  justify-content: center;
}
</style>
