<template>
  <div>
    <router-view></router-view>
    <spinner :loading="isLoading"></spinner>
  </div>
</template>

<script>
import router from "@/router/index.js";
import store from "@/store/index.js";
import bus from "@/utils/bus.js";
import Spinner from "@/components/common/Spinner.vue";

export default {
  name: "App",
  data() {
    return {
      isLoading: false,
    };
  },
  methods: {
    startSpinner() {
      this.isLoading = true;
    },
    endSpinner() {
      this.isLoading = false;
    },
  },
  components: {
    Spinner,
  },
  created() {
    // token 저장
    bus.$on("start:spinner", this.startSpinner);
    bus.$on("end:spinner", this.endSpinner);
    const accessToken = new URLSearchParams(location.search).get("token");
    if (accessToken) {
      localStorage.setItem("token", accessToken);
      router.replace("/");
    }

    const token = localStorage.getItem("token");

    if (!token) {
      router.replace("/login").catch(() => {});
      return;
    } else if (token) {
      store.dispatch("checkUser");
      return;
    }
  },
  beforeDestroy() {
    bus.$off("start:spinner");
    bus.$off("end:spinner");
  },
};
</script>

<style>
@import url(http://cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);

* {
  font-family: "Nanum Barun Gothic", sans-serif;
}
</style>
