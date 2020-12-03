<template>
  <div>
    <today-tasks-container
      :today-tasks="todayTasks"
      :expired-tasks="expiredTasks"
    ></today-tasks-container>
  </div>
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
