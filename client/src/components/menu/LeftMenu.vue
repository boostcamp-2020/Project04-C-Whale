<template>
  <div>
    <favorite-project-list></favorite-project-list>
    <project-list-container :project-infos="projectInfos"></project-list-container>
    <label-list :labels="labels"></label-list>
    <filter-list :priorities="priorities"></filter-list>
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
  computed: mapGetters(["projectInfos", "labels", "priorities"]),
  methods: {
    ...mapActions(["fetchProjectInfos", "fetchLabels", "fetchPriorities"]),
  },
  created() {
    this.fetchProjectInfos();
    this.fetchLabels();
    this.fetchPriorities();
  },
};
</script>
