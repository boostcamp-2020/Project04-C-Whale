<template>
  <v-app>
    <v-layout fill-height d-flex align-center justify-center flex-column>
      <div class="white d-flex flex-column justify-space-around align-center py-10">
        <img width="400" src="../assets/halgoraedo.png" />
        <div class="text-h1">NOT FOUND</div>
      </div>
      <alert></alert>
    </v-layout>
  </v-app>
</template>

<script>
import SpinnerMixin from "@/mixins/SpinnerMixins";

export default {
  mixins: [SpinnerMixin],
};
</script>
