<template>
  <v-container>
    <p class="text-h4">{{ currentProject.title }}</p>
    <v-list v-for="section in currentProject.sections" :key="section.id" class="mb-5">
      <v-list-item class="font-weight-black text-h5">{{ section.title }}</v-list-item>

      <div v-for="task in section.tasks" :key="task.id">
        <v-list-item>
          <v-list-item-action>
            <v-checkbox
              @click="updateTaskToDone({ projectId: $route.params.projectId, taskId: task.id })"
            ></v-checkbox>
          </v-list-item-action>

          <v-list-item-content>
            <v-list-item-title>{{ task.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list class="ml-10">
          <v-list-item v-for="childTask in task.tasks" :key="childTask.id">
            <v-list-item-action>
              <v-checkbox></v-checkbox>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>{{ childTask.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </div>

      <add-task />
    </v-list>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import AddTask from "./AddTask";

export default {
  name: "Project",
  methods: {
    ...mapActions(["fetchCurrentProject", "updateTaskToDone"]),
  },
  computed: mapGetters(["currentProject"]),
  components: { AddTask },
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
};
</script>

<style>
.toggle {
  width: 50px;
}
</style>
