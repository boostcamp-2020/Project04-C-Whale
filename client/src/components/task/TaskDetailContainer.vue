<template>
  <v-card v-if="task">
    <v-list-item>
      <v-list-item-icon class="mr-1 py-3">
        <v-icon small :color="task.section.project.color">mdi-circle</v-icon>
      </v-list-item-icon>
      <v-list-item-content>
        <v-list-item-title class="font-14 white-space-normal" v-text="task.section.project.title">
        </v-list-item-title>
      </v-list-item-content>
      <v-list-item-action>
        <v-btn icon @click="hideTaskModal()">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-list-item-action>
    </v-list-item>

    <div class="task_container mr-10">
      <TaskItem :task="task" />
    </div>
    <div class="px-4 task-detail-tabs">
      <TaskDetailTabs
        :tasks="this.task.tasks"
        :tabList="this.tabList"
        :comments="this.comments"
        :projectId="this.$route.params.projectId"
        :sectionId="this.task.sectionId"
        :isParent="this.task.parentId === null"
      />
    </div>
  </v-card>
</template>

<script>
import TaskItem from "@/components/project/TaskItem";
import TaskDetailTabs from "@/components/task/TaskDetailTabs";
import SpinnerMixin from "@/mixins/SpinnerMixins";
import { mapState, mapActions } from "vuex";

export default {
  components: { TaskItem, TaskDetailTabs },
  props: {
    task: Object,
  },
  data() {
    return {
      comments: [],
      tabList: {
        childTask: { title: "하위 작업", count: 0 },
        comment: { title: "댓글", count: 0 },
        bookmark: { title: "북마크", count: 0 },
      },
    };
  },
  computed: {
    ...mapState({ commentsMap: (state) => state.comment.commentsMap }),
  },
  methods: {
    ...mapActions(["fetchAllComments"]),
    hideTaskModal() {
      this.$emit("hideTaskModal");
    },
  },
  created() {
    this.comments = this.commentsMap[this.$route.params.taskId];
    this.tabList.childTask.count = this.task ? this.task.tasks.length : 0;
    this.tabList.comment.count = this.comments ? this.comments.length : 0;
    this.tabList.bookmark.count = this.bookmarks ? this.bookmarks.length : 0;
  },
  mixins: [SpinnerMixin],
};
</script>

<style lang="scss">
.task-detail-tabs {
  height: 50vw;
}

@media screen and (max-width: 512px) {
  .task-detail-tabs {
    height: 100vw;
  }
}
</style>
