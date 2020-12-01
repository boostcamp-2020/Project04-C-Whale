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
  created: () => {
    // token 저장
    const accessToken = location.search.split("token=")[1];
    if (accessToken) {
      store.dispatch("setToken", { accessToken });
    }

    if (!localStorage.getItem("token")) {
      router.replace("/login").catch(() => {});
    } else {
      store.dispatch("checkUser");
    }
  },
};
</script>
