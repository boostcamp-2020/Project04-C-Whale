<template>
  <div class="project-container">
    <div class="project-header">
      <v-list-item>
        <v-list-item-content class="text-h5">
          <updatable-title
            v-if="currentProject.title"
            :originalTitle="currentProject.title"
            :parent="currentProject"
            type="project"
          />
        </v-list-item-content>

        <v-menu :offset-y="true">
          <template v-slot:activator="{ on }">
            <v-list-item-action>
              <v-btn icon v-on="on">
                <v-icon>mdi-dots-horizontal</v-icon>
              </v-btn>
            </v-list-item-action>
          </template>
          <v-list>
            <v-list-item> 섹션 추가 </v-list-item>
          </v-list>
        </v-menu>
      </v-list-item>
    </div>

    <v-list v-for="section in currentProject.sections" :key="section.id" class="mb-5">
      <v-list-item class="font-weight-black text-h6">
        <updatable-title :originalTitle="section.title" :parent="section" type="section" />
      </v-list-item>

      <div v-for="task in section.tasks" :key="task.id" class="task-container">
        <task-item @pop="showTaskModal(task.id)" :task="task" />

        <v-divider />

        <div class="childTaskContainer ml-10" v-for="childTask in task.tasks" :key="childTask.id">
          <task-item :task="childTask" />
        </div>
      </div>

      <add-task :projectId="section.projectId" :sectionId="section.id" />
    </v-list>
    <v-dialog v-model="dialog" max-width="290" @click:outside="hideTaskModal()">
      <router-view />
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import AddTask from "./AddTask";
import TaskItem from "./TaskItem";
import UpdatableTitle from "../common/UpdatableTitle";
import router from "@/router";

export default {
  data() {
    return {
      dialog: !!this.$route.params.taskId,
      projectId: this.$route.params.projectId,
    };
  },
  methods: {
    ...mapActions(["fetchCurrentProject", "updateTaskToDone"]),
    showTaskModal(taskId) {
      this.dialog = true;
      router
        .push({ name: "TaskDetail", params: { taskId, projectId: this.projectId } })
        .catch(() => {});
    },
    hideTaskModal() {
      router.push(`/project/${this.projectId}`);
    },
    callModal() {
      this.dialog = true;
    },
  },
  computed: mapGetters(["currentProject"]),
  components: { AddTask, TaskItem, UpdatableTitle },
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
};
</script>

<style>
.project-header {
  min-width: 450px;
}
.task-container {
  min-width: 450px;
}
.project-container {
  width: 100%;
  max-width: 600px;
}
</style>
