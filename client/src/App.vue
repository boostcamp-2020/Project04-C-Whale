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
    if (localStorage.getItem("token")) {
      router.push("/today").catch(() => {});
    } else {
      router.push("/login").catch(() => {});
    }
    console.log(process.env.VUE_APP_TITLE);
  },
};
</script>
