<template>
  <div>
    <project-container v-if="projectList[projectId]" :project="projectList[projectId]" />
    <alert></alert>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import ProjectContainer from "../components/project/ProjectContainer";
import Alert from "@/components/common/Alert";
import ListMixin from "@/mixins/ListMixins.js";

export default {
  components: { ProjectContainer, Alert },
  methods: {
    ...mapActions(["fetchCurrentProject"]),
  },
  data() {
    return {
      projectId: this.$route.params.projectId,
    };
  },
  computed: {
    ...mapGetters(["projectList"]),
  },
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
  mixins: [ListMixin],
};
</script>
