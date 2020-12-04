<template>
  <div class="project-container">
    <div class="project-header">
      <v-list-item>
        <v-list-item-content class="text-h5">
          <updatable-title
            v-if="project.title"
            :originalTitle="project.title"
            :parent="project"
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

    <v-list v-for="section in project.sections" :key="section.id" class="mb-5">
      <v-list-item class="font-weight-black text-h6">
        <updatable-title :originalTitle="section.title" :parent="section" type="section" />
      </v-list-item>

      <div v-for="(task, index) in section.tasks" :key="task.id" class="task-container">

        <task-item :section="section" :task="task" :position="index" />
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
import { mapActions } from "vuex";
import AddTask from "@/components/project/AddTask";
import TaskItem from "@/components/project/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";

export default {
  props: {
    project: Object,
  },
  data() {
    return {
      projectId: this.$route.params.projectId,
    };
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
  },
  components: { AddTask, TaskItem, UpdatableTitle },
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

.v-dialog {
  max-width: 80%;
  min-height: 80%;
  background-color: white;
}
</style>
