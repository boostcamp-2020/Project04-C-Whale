<template>
  <div>
    <favorite-project-list></favorite-project-list>
    <v-list-group :value="true" no-action sub-group>
      <template v-slot:activator>
        <v-list-item-content>
          <v-list-item-title>프로젝트</v-list-item-title>
        </v-list-item-content>
      </template>
      <v-list-item v-for="project in projectInfos" :key="project.id">
        <v-list-item-content>
          <v-list-item-title>{{ project.title }} {{ project.taskCount }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-group>
  </div>
</template>

<script>
import FavoriteProjectList from "./FavoriteProjectList";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    "favorite-project-list": FavoriteProjectList,
  },
  computed: mapGetters(["projectInfos"]),
  methods: {
    ...mapActions(["fetchProjectInfos"]),
  },
  created() {
    this.fetchProjectInfos();
  },
};
</script>
