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
      // this.$store.commit('LOGIN', accessToken);
      location.href = "/";
    }
    if (localStorage.getItem("token")) {
      // router.push("/today").catch(() => {});
      router.push("/project/b7f253e5-7b6b-4ee2-b94e-369ffcdffb5f").catch(() => {});
    } else {
      router.push("/login").catch(() => {});
    }
  },
};
</script>
