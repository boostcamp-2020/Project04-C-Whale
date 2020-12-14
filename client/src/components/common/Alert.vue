<template>
  <div class="alert">
    <v-alert
      v-if="alert.message"
      :value="!!alert.message"
      :type="alert.type"
      :color="alert.type === 'success' ? 'whaleGreen' : null"
      dismissible
      @input="CLEAR_ALERT()"
      >{{ alert.message }}</v-alert
    >
  </div>
</template>

<script>
// TODO: success color값 바꾸기 -whaleGreen or whaleBlue
import { mapState, mapMutations } from "vuex";

export default {
  computed: {
    ...mapState({ alert: (state) => state.alert.alert }),
  },
  methods: {
    ...mapMutations(["CLEAR_ALERT"]),
  },
  beforeUpdate() {
    if (this.alert.message) {
      setTimeout(() => this.CLEAR_ALERT(), 3000);
    }
  },
};
</script>

<style lang="scss">
.alert {
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translate(-50%, 0);
  z-index: 900;
}
</style>
