<template>
  <div>
    <FavoriteProjectList
      v-if="managedProject && favoriteProjectInfos"
      :managed-project="managedProject"
      :task-count="taskCount"
      :favorite-project-infos="favoriteProjectInfos"
    />
    <ProjectListContainer :project-infos="namedProjectInfos" />
    <!-- <LabelList :labels="labels" />
    <FilterList :priorities="priorities" /> -->
  </div>
</template>

<script>
import FavoriteProjectList from "./FavoriteProjectList";
import ProjectListContainer from "./ProjectListContainer";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    FavoriteProjectList,
    ProjectListContainer,
  },
  computed: mapGetters([
    "namedProjectInfos",
    "favoriteProjectInfos",
    "managedProject",
    "todayProject",
    "taskCount",
  ]),
  methods: {
    ...mapActions(["fetchProjectInfos", "fetchAllTasks"]),
  },
  created() {
    this.fetchProjectInfos();
    this.fetchAllTasks();
  },
};
</script>

<style lang="scss"></style>
