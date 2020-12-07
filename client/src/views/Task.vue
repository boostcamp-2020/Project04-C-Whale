<template>
  <v-dialog v-model="dialog" :retain-focus="false" @click:outside="hideTaskModal()">
    <task-detail-container
      @hideTaskModal="hideTaskModal"
      :task="currentTask"
      :projectTitle="projectTitle"
    ></task-detail-container>
  </v-dialog>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskDetailContainer from "@/components/task/TaskDetailContainer.vue";

export default {
  name: "Task",
  data() {
    return {
      dialog: true,
      projectTitle: "무제",
    };
  },
  components: { TaskDetailContainer },
  methods: {
    ...mapActions(["fetchCurrentTask"]),
    hideTaskModal() {
      this.$router.go(-1);
    },
  },
  computed: {
    ...mapGetters(["currentTask", "namedProjectInfos"]),
  },

  async created() {
    await this.fetchCurrentTask(this.$route.params.taskId);
    this.projectTitle = this.namedProjectInfos.find(
      (project) => project.id === this.currentTask.projectId
    ).title;
  },
};
</script>
