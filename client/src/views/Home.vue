<template>
  <v-app v-if="isAuth">
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
import { mapState } from "vuex";

export default {
  name: "Home",
  components: {
    "my-header": Header,
  },
  computed: {
    ...mapState({
      isAuth: (state) => state.auth.isAuth,
    }),
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
