<template>
  <div>
    citest
    <Spinner :loading="isLoading" />
    <router-view></router-view>
  </div>
</template>

<script>
import router from "@/router";
import Spinner from "@/components/common/Spinner";
import bus from "@/utils/bus";
import { mapActions } from "vuex";

export default {
  name: "App",
  components: {
    Spinner,
  },
  data() {
    return {
      isLoading: false,
      error: false,
    };
  },
  created() {
    bus.$on("start:spinner", this.startSpinner);
    bus.$on("end:spinner", this.endSpinner);

    // token 저장
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
      this.checkUser();
      return;
    }
  },
  beforeDestroy() {
    bus.$off("start:spinner");
    bus.$off("end:spinner");
  },
  methods: {
    ...mapActions(["checkUser"]),
    startSpinner() {
      if (this.isLoading) return;
      this.isLoading = true;
    },
    endSpinner() {
      if (!this.isLoading) return;
      this.isLoading = false;
    },
  },
};
</script>

<style>
@import url(http://cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);

* {
  font-family: "Nanum Barun Gothic", sans-serif;
}
</style>
