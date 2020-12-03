<template>
  <div>
    <project-container :project="currentProject" />
    <alert></alert>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ProjectContainer from "../components/project/ProjectContainer";
import Alert from "@/components/common/Alert";

export default {
  components: { ProjectContainer, Alert },
  methods: {
    ...mapActions(["fetchCurrentProject"]),
  },
  computed: mapGetters(["currentProject"]),
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
  beforeRouteUpdate(to, from, next) {
    this.fetchCurrentProject(to.params.projectId);
    next();
  },
};
</script>
