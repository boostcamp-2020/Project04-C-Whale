<template>
  <v-list-item>
    <v-list-item-action>
      <v-radio
        dense
        @click="updateTaskToDone({ projectId: task.projectId, taskId: task.id })"
        class="done-checkbox"
      ></v-radio>
    </v-list-item-action>

    <div class="task-div" @click="showModal({ taskId: task.id })">
      <v-list-item-content>
        <v-list-item-title>{{ task.title }}</v-list-item-title>
      </v-list-item-content>
    </div>

    <v-dialog v-model="dialog" max-width="290" @click:outside="hideModal()">
      <router-view />
    </v-dialog>
  </v-list-item>
</template>

<script>
import { mapActions } from "vuex";
import router from "@/router";

export default {
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
    showModal(taskId) {
      this.dialog = true;
      router.push({ name: "TaskDetail", params: taskId });
    },
    hideModal() {
      // this.dialog = false;
      // router.go(-1);
      router.push({ name: "Project" });
    },
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
