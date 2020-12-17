<template>
  <v-col cols="12" sm="12" lg="10" md="10">
    <project-container
      v-if="projectList[$route.params.projectId]"
      :project="projectList[$route.params.projectId]"
      :sections="projectList[$route.params.projectId].sections"
    />
  </v-col>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import ProjectContainer from "../components/project/ProjectContainer";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";
import bus from "@/utils/bus";

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
  async created() {
    bus.$emit("start:spinner");
    await this.fetchCurrentProject(this.$route.params.projectId);
    bus.$emit("end:spinner");
  },
  mixins: [SpinnerMixin],
};
</script>
