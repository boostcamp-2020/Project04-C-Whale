<template>
  <div>
    <favorite-project-list
      v-if="managedProject"
      :managed-project="managedProject"
      :task-count="taskCount"
    ></favorite-project-list>
    <project-list-container :project-infos="namedProjectInfos"></project-list-container>
    <label-list :labels="labels"></label-list>
    <filter-list :priorities="priorities"></filter-list>
    <alert></alert>
  </div>
</template>

<script>
import FavoriteProjectList from "./FavoriteProjectList";
import ProjectListContainer from "./ProjectListContainer";
import LabelList from "./LabelList";
import FilterList from "./FilterList";
import Alert from "@/components/common/Alert";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    FavoriteProjectList,
    ProjectListContainer,
    LabelList,
    FilterList,
    Alert,
  },
  computed: mapGetters([
    "namedProjectInfos",
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
  mounted() {
    this.$nextTick(() => {
      this.fetchAllTasks();
      this.fetchProjectInfos();
      this.fetchTodayProject();
      this.fetchLabels();
      this.fetchPriorities();
    });
  },
};
</script>

<style lang="scss"></style>
