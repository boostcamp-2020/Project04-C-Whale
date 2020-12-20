<template>
  <v-progress-circular
    v-if="loading"
    indeterminate
    :size="70"
    :width="7"
    color="whaleGreen"
    class="spinner-container"
  ></v-progress-circular>
</template>

<script>
export default {
  props: {
    loading: Boolean,
  },
};
</script>

<style lang="scss">
.spinner-container {
  position: absolute;
  top: 45%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
}
.v-progress-circular__overlay {
  stroke: #07c4a3 !important;
}
</style>
