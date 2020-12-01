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
    // eslint-disable-next-line no-unused-vars
    const [_, accessToken] = location.search.split("token=");
    if (accessToken) {
      localStorage.setItem("token", accessToken);
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
  mounted() {},
};
</script>
