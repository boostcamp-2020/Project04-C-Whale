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
    <alert />
  </v-app>
</template>

<script>
import Header from "@/components/common/Header";
import Alert from "@/components/common/Alert";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";

import { mapState } from "vuex";

export default {
  name: "Home",
  components: {
    "my-header": Header,
    Alert,
  },
  computed: {
    ...mapState({
      isAuth: (state) => state.auth.isAuth,
    }),
  },
  mixins: [SpinnerMixin],
};
</script>

<style>
.router-view-container {
  padding: 10px 20%;
  display: flex;
  justify-content: center;
}
</style>
