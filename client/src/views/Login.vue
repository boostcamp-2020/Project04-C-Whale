<template>
  <v-app>
    <v-layout class="whaleGreen" fill-height d-flex align-center justify-center flex-column>
      <div class="login-layout white d-flex flex-column justify-space-around align-center py-10">
        <img width="200" src="../assets/halgoraedo.png" />
        <a :href="serverURL">
          <img width="200" src="../assets/naverlogin.png" />
        </a>
      </div>
    </v-layout>
  </v-app>
</template>

<script>
export default {
  name: "Login",
  data: function () {
    return {
      serverURL: process.env.VUE_APP_SERVER_URL + "/api/user/oauth/naver",
    };
  },
};
</script>

<style lang="scss">
.login-layout {
  width: 360px;
  height: 360px;
  border-radius: 0.5rem;
}
</style>
