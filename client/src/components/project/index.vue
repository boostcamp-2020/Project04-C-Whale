<template>
  <v-container>
    <v-list v-for="section in currentProject.sections" :key="section.id">
      <v-list-group :value="true">
        <template v-slot:activator>
          <v-list-item-title>{{ section.title }}</v-list-item-title>
        </template>
        <v-list-group
          :value="true"
          no-action
          sub-group
          v-for="task in section.tasks"
          :key="task.id"
          class=""
        >
          <template v-slot:activator class="toggle">
            <v-list-item-action>
              <v-checkbox :input-value="active"></v-checkbox>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>{{ task.title }}</v-list-item-title>
            </v-list-item-content>
          </template>
          <v-list-item v-for="childTask in task.tasks" :key="childTask.id">
            <v-list-item-action>
              <v-checkbox :input-value="active"></v-checkbox>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title v-text="childTask.title"></v-list-item-title
            ></v-list-item-content>
          </v-list-item>
        </v-list-group>
      </v-list-group>
    </v-list>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {
  name: "Project",
  methods: {
    ...mapActions(["fetchCurrentProject"]),
  },
  computed: mapGetters(["currentProject"]),
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
