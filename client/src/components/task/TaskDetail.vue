<template>
  <!-- <v-dialog v-model="dialog" :retain-focus="false" @click:outside="hideTaskModal()"> -->
  <v-flex>
    <v-list-item class="flex-column">
      <v-list-item-group class="d-flex">
        <v-list-item-title>
          <div class="task_detail-project_title">{{ projectTitle }}</div>
        </v-list-item-title>
        <v-btn icon @click="hideTaskModal()">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-list-item-group>

      <div class="task_container ml-10 mr-10">
        <task-item :task="task" />
      </div>
      <v-tabs v-model="active" color="#1C2B82" slider-color="#07C4A3">
        <v-tab v-for="tabTitle in this.taskTaps" :key="tabTitle" ripple> {{ tabTitle }} </v-tab>
        <v-tab-item v-for="childTask in this.task.tasks" :key="childTask">
          <v-card flat>
            <v-card-text>{{ text }}</v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs>
      <div>{{ task }} hi!!</div>
    </v-list-item>
  </v-flex>
  <!-- </v-dialog> -->
</template>

<script>
import TaskItem from "@/components/project/TaskItem";

export default {
  data() {
    return {
      active: null,
      taskTaps: ["하위 작업", "댓글", "북마크"],
    };
  },
  props: {
    task: Object,
    projectTitle: String,
  },

  components: { TaskItem },

  methods: {
    hideTaskModal() {
      this.$emit("hideTaskModal");
    },
    next() {
      const active = parseInt(this.active);
      this.active = active < 2 ? active + 1 : 0;
    },
  },
  computed: {},
  created() {},
  mounted() {},
};
</script>

<style>
.v-list-item {
  align-items: initial;
}
</style>
