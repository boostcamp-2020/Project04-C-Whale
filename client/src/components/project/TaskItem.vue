<template>
  <v-list-item>
    <v-list-item-action>
      <v-radio
        dense
        @click="updateTaskToDone({ projectId: task.projectId, taskId: task.id })"
        class="done-checkbox"
      ></v-radio>
    </v-list-item-action>

    <div class="task-div" @click="showModal()">
      <v-list-item-content>
        <v-list-item-title>{{ task.title }}</v-list-item-title>
      </v-list-item-content>
    </div>
  </v-list-item>
</template>

<script>
import { mapActions } from "vuex";

export default {
  data() {
    return {};
  },
  props: { task: Object },
  methods: {
    ...mapActions(["updateTaskToDone"]),
    showModal() {
      this.$emit("pop");
    },
  },
};
</script>

<style>
.container {
  min-width: 500px;
}

.done-checkbox {
  border-radius: 100%;
}

.task-div {
  width: 100%;
}
.task-div:hover {
  border-radius: 10px;
  cursor: pointer;
  background-color: #1c2b82;
  color: white;
  padding-left: 10px;
}
</style>
