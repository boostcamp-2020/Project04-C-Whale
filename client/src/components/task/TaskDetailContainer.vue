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
        :tasks="task.tasks"
        :comments="commentsMap[this.$route.params.taskId]"
        :bookmarks="bookmarkMap[this.$route.params.taskId]"
        :projectId="$route.params.projectId"
        :sectionId="task.sectionId"
        :isParent="task.parentId === null"
      />
    </div>
  </v-card>
</template>

<script>
import TaskItem from "@/components/task/TaskItem";
import TaskDetailTabs from "@/components/task/TaskDetailTabs";
import SpinnerMixin from "@/mixins/SpinnerMixins";
import { mapState } from "vuex";

export default {
  components: { TaskItem, TaskDetailTabs },
  props: {
    task: Object,
  },
  data() {
    return {
      comments: [],
    };
  },
  computed: {
    ...mapState({
      commentsMap: (state) => state.comment.commentsMap,
      bookmarkMap: (state) => state.bookmark.bookmarkMap,
    }),
  },
  methods: {
    hideTaskModal() {
      this.$emit("hideTaskModal");
    },
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
