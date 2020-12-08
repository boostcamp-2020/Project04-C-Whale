<template>
  <today-tasks-container :today-tasks="todayTasks" :expired-tasks="expiredTasks" />
</template>

<script>
import TodayTasksContainer from "@/components/today/TodayTasksContainer";
import { mapGetters } from "vuex";

export default {
  name: "Today",
  components: {
    TodayTasksContainer,
  },
  computed: mapGetters(["todayTasks", "expiredTasks"]),
};
</script>
