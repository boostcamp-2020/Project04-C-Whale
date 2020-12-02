<template>
  <v-list-group :value="false" sub-group active-class="list-active">
    <template v-slot:activator>
      <v-list-item-content>
        <v-list-item-title class="font-14">프로젝트</v-list-item-title>
      </v-list-item-content>
    </template>
    <v-list-item-group>
      <v-list-item v-for="project in projectInfos" :key="project.id">
        <v-list-item-icon class="mr-4">
          <v-icon color="red">mdi-circle</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title class="font-14"
            >{{ project.title }} {{ project.taskCount }}</v-list-item-title
          >
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>
  </v-list-group>
</template>

<script>
export default {
  props: {
    projectInfos: Array,
  },
};
</script>
