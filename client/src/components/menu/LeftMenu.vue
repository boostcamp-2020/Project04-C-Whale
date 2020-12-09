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
import LabelList from "./LabelList";
import FilterList from "./FilterList";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    FavoriteProjectList,
    ProjectListContainer,
    LabelList,
    FilterList,
  },
  computed: mapGetters([
    "namedProjectInfos",
    "favoriteProjectInfos",
    "managedProject",
    "labels",
    "priorities",
    "todayProject",
    "nextDayTaskCount",
    "taskCount",
    "todayTasks",
  ]),
  methods: {
    ...mapActions([
      "fetchProjectInfos",
      "fetchTodayProject",
      "fetchLabels",
      "fetchPriorities",
      "fetchAllTasks",
    ]),
  },
  created() {
    this.fetchAllTasks();
    this.fetchProjectInfos();
    this.fetchTodayProject();
    this.fetchLabels();
    this.fetchPriorities();
  },
};
</script>

<style lang="scss"></style>
