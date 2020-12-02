<template>
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
</template>

<script>
export default {
  props: {
    projectInfos: Array,
  },
};
</script>
