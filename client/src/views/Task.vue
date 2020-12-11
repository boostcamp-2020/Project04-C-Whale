<template>
  <v-dialog v-model="dialog" :retain-focus="false" @click:outside="hideTaskModal()">
    <task-detail-container
      v-if="this.projectTitle"
      @hideTaskModal="hideTaskModal"
      :task="currentTask"
      :comments="comments"
      :projectTitle="projectTitle"
    ></task-detail-container>
    <div v-else v-ripple="{ center: true }" class="text-center elevation-2 pa-12 headline">
      데이터를 불러오는 중입니다
    </div>
  </v-dialog>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskDetailContainer from "@/components/task/TaskDetailContainer.vue";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";

export default {
  name: "Task",
  data() {
    return {
      dialog: true,
      projectTitle: undefined,
    };
  },
  components: { TaskDetailContainer },
  methods: {
    ...mapActions(["fetchCurrentTask", "fetchComments"]),
    hideTaskModal() {
      this.$router.go(-1);
    },
  },
  computed: {
    ...mapGetters(["currentTask", "projectInfos", "comments"]),
  },

  async created() {
    await Promise.all([
      this.fetchCurrentTask(this.$route.params.taskId),
      this.fetchComments(this.$route.params.taskId),
    ]);

    this.projectTitle = this.projectInfos.find(
      (project) => project.id === this.$route.params.projectId
    ).title;
  },
  mixins: [SpinnerMixin],
};
</script>
<style>
.v-dialog {
  max-height: 80% !important;
}
</style>
