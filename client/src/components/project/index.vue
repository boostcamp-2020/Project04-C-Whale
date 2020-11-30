<template>
  <v-container>
    <v-list v-for="section in currentProject.sections" :key="section.id">
      {{ section.title }}
      <v-list flat subheader three-line v-for="task in section.tasks" :key="task.id">
        <!-- <v-subheader>{{ sction.title }}</v-subheader> -->

        <v-list-item>
          <template v-slot:default="{ active }">
            <v-list-item-action>
              <v-checkbox :input-value="active"></v-checkbox>
            </v-list-item-action>

            <v-list-item-content>
              <v-list-item-title>{{ task.title }}</v-list-item-title>
              <v-list-item-subtitle
                >Notify me about updates to apps or games that I downloaded</v-list-item-subtitle
              >
            </v-list-item-content>
          </template>
        </v-list-item>
      </v-list>
    </v-list>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {
  name: "Project",
  methods: {
    ...mapActions(["fetchCurrentProject"]),
  },
  computed: mapGetters(["currentProject"]),
  created() {
    this.fetchCurrentProject(this.$route.params.projectId);
  },
};
</script>

<style></style>
