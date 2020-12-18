<template>
  <div>
    <FavoriteProjectList
      v-if="managedProject && favoriteProjectInfos"
      :managed-project="managedProject"
      :task-count="taskCount"
      :favorite-project-infos="favoriteProjectInfos"
    />
    <ProjectListContainer :project-infos="namedProjectInfos" />
    <BookmarkList />
    <!-- <LabelList :labels="labels" />
    <FilterList :priorities="priorities" /> -->
  </div>
</template>

<script>
import FavoriteProjectList from "./FavoriteProjectList";
import ProjectListContainer from "./ProjectListContainer";
import BookmarkList from "./BookmarkList";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    FavoriteProjectList,
    ProjectListContainer,
    BookmarkList,
  },
  computed: mapGetters([
    "namedProjectInfos",
    "favoriteProjectInfos",
    "managedProject",
    "taskCount",
  ]),
  created() {
    this.fetchProjectInfos();
    this.fetchAllTasks();
  },
  methods: {
    ...mapActions(["fetchProjectInfos", "fetchAllTasks"]),
  },
};
</script>

<style lang="scss"></style>
