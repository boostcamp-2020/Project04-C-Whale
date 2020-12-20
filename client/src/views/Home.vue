<template>
  <v-app v-if="isAuth">
    <Header />
    <v-main>
      <div class="router-view-container px-4 py-4 px-sm-1 py-sm-1">
        <keep-alive>
          <router-view :key="$route.params.projectId"></router-view>
        </keep-alive>
      </div>
    </v-main>
    <alert />
  </v-app>
</template>

<script>
import Header from "@/components/home/MainHeader";
import Alert from "@/components/common/Alert";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";

import { mapState } from "vuex";

export default {
  name: "Home",
  components: {
    Header,
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
  display: flex;
  justify-content: center;
  height: 100%;
}
@media screen and (max-width: 600px) {
  .router-view-container.px-4.py-4 {
    padding-left: 0px !important;
    padding-right: 0px !important;
  }
}
</style>
