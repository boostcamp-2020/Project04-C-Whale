<template>
  <v-dialog
    class="task-detail"
    v-show="dialog"
    v-model="dialog"
    max-width="800"
    :retain-focus="false"
    @click:outside="hideTaskModal()"
  >
    <keep-alive>
      <TaskDetailContainer
        v-if="tasks && tasks.length !== 0"
        @hideTaskModal="hideTaskModal"
        :task="task"
        :key="$route.params.taskId"
      />
    </keep-alive>
  </v-dialog>
</template>

<script>
import { mapActions, mapState } from "vuex";
import TaskDetailContainer from "@/components/task/TaskDetailContainer.vue";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";
import taskAPI from "@/api/task";
import bus from "@/utils/bus";

export default {
  name: "Task",
  data() {
    return {
      dialog: true,
      task: {},
      comments: [],
    };
  },
  computed: {
    ...mapState({ tasks: (state) => state.task.tasks }),
  },
  components: { TaskDetailContainer },
  methods: {
    ...mapActions(["fetchCurrentTask", "fetchComments", "fetchBookmarks"]),
    hideTaskModal() {
      this.$router.go(-1);
    },
  },
  watch: {
    tasks() {
      this.task = this.tasks.find((task) => task.id === this.$route.params.taskId);
    },
  },
  activated() {
    this.dialog = true;
  },
  deactivated() {
    this.dialog = false;
  },
  created: async function () {
    // 루트 할일 일 경우
    this.task = this.tasks.find((task) => task.id === this.$route.params.taskId);

    // let targetTask;
    if (this.task === undefined) {
      const result = await taskAPI.getTaskById(this.$route.params.taskId);
      this.task = result.data.task;
    }
    await this.fetchComments(this.$route.params.taskId);
    await this.fetchBookmarks(this.$route.params.taskId);
  },
  mixins: [SpinnerMixin],
};
</script>
<style>
@media screen and (max-width: 720px) {
  .v-dialog {
    width: 80%;
  }
}

@media screen and(max-width: 512px) {
  .v-dialog {
    width: 100%;
  }
}
</style>
