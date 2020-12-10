<template>
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
        <TaskItem :task="task" />
      </div>
      <TaskDetailTabs
        :tasks="this.task.tasks"
        :tabList="this.tabList"
        :comments="this.comments"
        :projectId="this.$route.params.projectId"
        :sectionId="this.task.sectionId"
      />
    </v-list-item>
  </v-flex>
</template>

<script>
import TaskItem from "@/components/project/TaskItem";
import TaskDetailTabs from "@/components/task/TaskDetailTabs";

export default {
  data() {
    return {
      tabList: {
        childTask: { title: "하위 작업", count: 0 },
        comment: { title: "댓글", count: 0 },
        bookmark: { title: "북마크", count: 0 },
      },
    };
  },
  props: {
    task: Object,
    comments: Array,
    projectTitle: String,
  },

  components: { TaskItem, TaskDetailTabs },

  methods: {
    hideTaskModal() {
      this.$emit("hideTaskModal");
    },
  },
  computed: {},
  created() {
    this.tabList.childTask.count = this.task.tasks.length;
    this.tabList.comment.count = this.comments.length;
    this.tabList.bookmark.count = 3;
  },
  mounted() {},
};
</script>

<style>
.v-list-item {
  align-items: initial;
}
</style>
