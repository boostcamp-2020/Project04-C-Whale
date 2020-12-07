<template>
  <v-tabs v-model="active" color="#1C2B82" slider-color="#07C4A3">
    <v-tab v-for="tabTitle in this.tabTitles" :key="tabTitle" ripple> {{ tabTitle }} </v-tab>
    <v-tab-item v-for="childTask in this.tasks" :key="childTask">
      <v-card flat>
        <task-item :task="childTask" />
        <!-- <v-card-text>{{ text }}</v-card-text> -->
      </v-card>
    </v-tab-item>
  </v-tabs>
</template>

<script>
export default {
  props: {
    tasks: Array,
    tabTitles: Array,
  },
  data() {
    return {
      active: null,
      taskTaps: ["하위 작업", "댓글", "북마크"],
    };
  },
  methods: {
    next() {
      const active = parseInt(this.active);
      this.active = active < 2 ? active + 1 : 0;
    },
  },
};
</script>

<style></style>
