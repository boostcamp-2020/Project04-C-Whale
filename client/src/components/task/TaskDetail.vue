<template>
  <div>
    <div>{{ currentTask.title }} hi!!</div>
    <div>{{ currentTask }}}</div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      dialog: false,
      taskId: this.$route.params.taskId,
    };
  },
  methods: {
    ...mapActions(["fetchCurrentTask"]),
  },
  computed: mapGetters(["currentTask"]),

  created() {
    this.fetchCurrentTask(this.$route.params.taskId);
  },
};
</script>

<style></style>
