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

      <div class="task_container mr-10">
        <task-item :task="task" />
      </div>
      <task-detail-tabs
        :tabTitles="this.taskTabs"
        :tasks="this.task.tasks"
        :projectId="this.task.projectId"
        :sectionId="this.task.sectionId"
      />
      <!-- <v-tabs v-model="active" color="#1C2B82" slider-color="#07C4A3">
        <v-tab v-for="tabTitle in this.taskTaps" :key="tabTitle" ripple> {{ tabTitle }} </v-tab>
        <v-tab-item v-for="childTask in this.task.tasks" :key="childTask">
          <v-card flat>
            <task-item :task="childTask" />
            <v-card-text>{{ text }}</v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs> -->
    </v-list-item>
  </v-flex>
  <!-- </v-dialog> -->
</template>

<script>
import TaskItem from "@/components/project/TaskItem";
import TaskDetailTabs from "@/components/task/TaskDetailTabs";

export default {
  data() {
    return {
      taskTabs: { childTaskTab: "하위 작업", taskCommentTab: "댓글", taskBookmarkTab: "북마크" },
    };
  },
  props: {
    task: Object,
    projectTitle: String,
  },

  components: { TaskItem, TaskDetailTabs },

  methods: {
    hideTaskModal() {
      this.$emit("hideTaskModal");
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
