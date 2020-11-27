<template>
  <router-view></router-view>
</template>

<script>
import router from "@/router/index.js";

export default {
  name: "App",
  data: () => ({
    //
  }),
  created: () => {
    const accessToken = location.search.split("token=")[1];
    if (accessToken) {
      localStorage.setItem("token", accessToken);
      location.href = "/";
    }
    if (localStorage.getItem("token")) {
      router.push("/today").catch(() => {});
    } else {
      router.push("/login").catch(() => {});
    }
  },
};
</script>
