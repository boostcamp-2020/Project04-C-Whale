<template>
  <div class="project-container">
    <div class="project-header">
      <v-list-item>
        <v-list-item-content>
          <p class="text-h5">{{ currentProject.title }}</p>
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
      <v-list-item class="font-weight-black text-h6">{{ section.title }}</v-list-item>

      <div v-for="task in section.tasks" :key="task.id" class="task-container">
        <task-item :task="task" />
        <v-divider />

        <div class="childTaskContainer ml-10" v-for="childTask in task.tasks" :key="childTask.id">
          <task-item :task="childTask" />
        </div>
      </div>

      <add-task :projectId="section.projectId" :sectionId="section.id" />
    </v-list>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import AddTask from "./AddTask";
import TaskItem from "./TaskItem";

export default {
  name: "ProjectContainer",
  methods: {
    ...mapActions(["fetchCurrentProject", "updateTaskToDone"]),
  },
  computed: mapGetters(["currentProject"]),
  components: { AddTask, TaskItem },
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
