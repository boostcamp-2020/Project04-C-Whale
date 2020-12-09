<template>
  <v-progress-circular
    v-if="loading"
    indeterminate
    :size="70"
    :width="7"
    color="red"
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
}
</style>
