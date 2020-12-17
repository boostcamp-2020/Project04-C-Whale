<template>
  <div>
    <LeftMenuFavoriteProjectList
      v-if="managedProject && favoriteProjectInfos"
      :managed-project="managedProject"
      :task-count="taskCount"
      :favorite-project-infos="favoriteProjectInfos"
    />
    <LeftMenuProjectListContainer :project-infos="namedProjectInfos" />
    <LeftMenuBookmarkList />
  </div>
</template>

<script>
import LeftMenuFavoriteProjectList from "./LeftMenuFavoriteProjectList";
import LeftMenuProjectListContainer from "./LeftMenuProjectListContainer";
import LeftMenuBookmarkList from "./LeftMenuBookmarkList";

import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    LeftMenuFavoriteProjectList,
    LeftMenuProjectListContainer,
    LeftMenuBookmarkList,
  },
  computed: mapGetters([
    "namedProjectInfos",
    "favoriteProjectInfos",
    "managedProject",
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
