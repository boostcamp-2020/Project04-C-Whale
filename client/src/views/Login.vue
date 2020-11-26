<template>
  <v-app>
    <v-layout class="whaleGreen" fill-height d-flex align-center justify-center flex-column>
      <div class="login-layout white d-flex flex-column justify-space-around align-center py-10">
        <img width="200" src="../assets/halgoraedo.png" />
        <a href="http://localhost:3000/api/user/oauth/naver">
          <img width="200" src="../assets/naverlogin.png" />
        </a>
      </div>
    </v-layout>
  </v-app>
</template>

<script>
export default {
  name: "Login",
};
</script>

<style lang="scss">
.login-layout {
  width: 360px;
  height: 360px;
  border-radius: 0.5rem;
}
</style>
