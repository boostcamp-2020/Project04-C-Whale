<template>
  <v-menu :offset-y="true">
    <template v-slot:activator="{ on }">
      <v-btn depressed color="normal" v-on="on" class="mr-1">
        <v-icon :color="selectedProject.color">mdi-inbox</v-icon>
        {{ selectedProject.title }}
      </v-btn>
    </template>

    <v-list>
      <v-list-item
        v-for="projectInfo in projectInfos"
        :key="projectInfo.id"
        @click="pickProject(projectInfo)"
      >
        <v-list-item-icon>
          <v-icon :color="projectInfo.color">mdi-inbox</v-icon>
        </v-list-item-icon>
        <v-list-item-title>{{ projectInfo.title }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  props: {
    projectId: String,
  },
  data() {
    return {
      selectedProject: {},
    };
  },
  methods: {
    pickProject(projectInfo) {
      this.selectedProject = projectInfo;
      this.$emit("pickProject", projectInfo);
    },
  },
  computed: {
    ...mapGetters(["projectInfos", "projectInfoById"]),
  },
  created() {
    this.selectedProject = this.projectInfoById(this.projectId);
  },
};
</script>

<style></style>
