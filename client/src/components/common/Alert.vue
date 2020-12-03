<template>
  <div class="alert">
    <v-alert
      v-if="alert.alert.type"
      :value="!!alert.alert.message"
      :type="alert.alert.type"
      dismissible
      @input="CLEAR_ALERT()"
      >{{ alert.alert.message }}</v-alert
    >
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";

export default {
  computed: {
    ...mapState(["alert"]),
  },
  methods: {
    ...mapMutations(["CLEAR_ALERT"]),
  },
  beforeUpdate() {
    setTimeout(() => this.CLEAR_ALERT(), 3000);
  },
};
</script>

<style lang="scss">
.alert {
  position: fixed;
  top: 0;
  left: 50%;
  transform: translate(-50%, 0);
}
</style>
