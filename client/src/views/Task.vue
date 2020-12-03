<template>
  <v-dialog v-model="dialog" :retain-focus="false" @click:outside="hideTaskModal()">
    <task-detail
      @hideTaskModal="hideTaskModal"
      :task="currentTask"
      :projectTitle="getProjectTitle"
    ></task-detail>
  </v-dialog>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskDetail from "@/components/task/TaskDetail.vue";

export default {
  name: "Task",
  data() {
    return {
      dialog: true,
      projectTitle: "무제",
    };
  },
  components: { TaskDetail },
  methods: {
    ...mapActions(["fetchCurrentTask"]),
    hideTaskModal() {
      this.$router.go(-1);
    },
  },
  computed: {
    ...mapGetters(["currentTask", "namedProjectInfos"]),
    getProjectTitle() {
      return this.namedProjectInfos.find((project) => project.id === this.currentTask.projectId)
        .title;
    },
  },

  created() {
    // console.log(this);
    this.fetchCurrentTask(this.$route.params.taskId);
  },
  // mounted() {
  //   this.projectTitle = this.getProjectTitle();
  // },
  // beforeRouteUpdate(to, from, next) {
  //   this.fetchCurrentTask(to.params.taskId);
  //   next();
  // },
};
</script>
