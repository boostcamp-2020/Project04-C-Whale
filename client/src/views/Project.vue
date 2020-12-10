<template>
  <div>
    <project-container
      v-if="projectList[$route.params.projectId]"
      :project="projectList[$route.params.projectId]"
    />
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import ProjectContainer from "../components/project/ProjectContainer";
import ListMixin from "@/mixins/ListMixins.js";

export default {
  components: { ProjectContainer },
  methods: {
    ...mapActions(["fetchCurrentProject"]),
  },
  data() {
    return {};
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
