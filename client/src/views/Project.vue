<template>
  <project-container :project="currentProject" />
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ProjectContainer from "../components/project/ProjectContainer";

export default {
  components: { ProjectContainer },
  methods: {
    ...mapActions(["fetchCurrentProject"]),
  },
  computed: mapGetters(["currentProject"]),
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
  beforeRouteUpdate(to, from, next) {
    this.fetchCurrentProject(to.params.projectId);
  },
};
</script>
