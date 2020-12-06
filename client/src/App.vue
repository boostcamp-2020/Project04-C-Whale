<template>
  <router-view></router-view>
</template>

<script>
import router from "@/router/index.js";
import store from "@/store/index.js";

export default {
  name: "App",
  data: () => ({
    //
  }),
  created() {
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
      store.dispatch("checkUser");
      return;
    }
  },
};
</script>
