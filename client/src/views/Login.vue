<template>
  <v-app>
    <v-layout class="grey lighten-5" fill-height d-flex align-center justify-center flex-column>
      <div class="login-layout d-flex flex-column justify-space-around align-center py-10">
        <img width="200" src="../assets/halgoraedo.png" />
        <!-- <a :href="OAuthURL">
          <img width="200" src="../assets/naverlogin.png" />
        </a> -->
        <a :href="OAuthGoogleURL">
          <img width="200" src="../assets/googlelogin.png" />
        </a>
        <p>네이버 로그인은 준비중입니다</p>
      </div>
      <alert></alert>
    </v-layout>
  </v-app>
</template>

<script>
import Alert from "@/components/common/Alert";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";

export default {
  components: { Alert },
  name: "Login",
  data() {
    return {
      OAuthURL: process.env.VUE_APP_SERVER_URL + "/api/user/oauth/naver",
      OAuthGoogleURL: process.env.VUE_APP_SERVER_URL + "/api/auth/google",
    };
  },
  mixins: [SpinnerMixin],
};
</script>

<style lang="scss">
.login-layout {
  width: 360px;
  height: 360px;
  border-radius: 0.5rem;
  background-color: white;
  border: 1px solid #dbdbdb !important;
}
</style>
