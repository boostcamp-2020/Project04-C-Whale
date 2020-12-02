<template>
  <v-list-item>
    <v-list-item-action>
      <v-radio
        dense
        @click="updateTaskToDone({ projectId: task.projectId, taskId: task.id })"
        class="done-checkbox"
      ></v-radio>
    </v-list-item-action>

    <v-list-item-content>
      <v-list-item-title>{{ task.title }}</v-list-item-title>
    </v-list-item-content>
  </v-list-item>
</template>

<script>
import { mapActions } from "vuex";

export default {
  methods: {
    ...mapActions(["updateTaskToDone"]),
  },
  props: ["task"],
};
</script>

<style>
.container {
  min-width: 500px;
}

.done-checkbox {
  border-radius: 100%;
}
</style>
