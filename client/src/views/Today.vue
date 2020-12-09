<template>
  <today-tasks-container :today-tasks="todayTasks" :expired-tasks="expiredTasks" />
</template>

<script>
import TodayTasksContainer from "@/components/today/TodayTasksContainer";
import { mapGetters } from "vuex";
import ListMixin from "@/mixins/ListMixins.js";

export default {
  name: "Today",
  components: {
    TodayTasksContainer,
  },
  computed: mapGetters(["todayTasks", "expiredTasks"]),
  mixins: [ListMixin],
};
</script>
