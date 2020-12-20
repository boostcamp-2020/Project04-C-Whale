<template>
  <v-container fluid>
    <v-col class="px-sm-0 py-sm-0" cols="12" sm="12" lg="10" md="8">
      <project-container
        v-if="projectList[$route.params.projectId]"
        :project="projectList[$route.params.projectId]"
        :sections="projectList[$route.params.projectId].sections"
      />
    </v-col>
  </v-container>
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
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
  mixins: [SpinnerMixin],
};
</script>
