<template>
  <v-col cols="12" sm="12" lg="8" md="10">
    <TodayTasksContainer :today-tasks="todayTasks" :expired-tasks="expiredTasks" />
  </v-col>
</template>

<script>
import TodayTasksContainer from "@/components/today/TodayTasksContainer";
import { mapGetters } from "vuex";
import SpinnerMixin from "@/mixins/SpinnerMixins.js";

export default {
  name: "Today",
  components: {
    TodayTasksContainer,
  },
  computed: { ...mapGetters(["todayTasks", "expiredTasks"]) },
  mixins: [SpinnerMixin],
};
</script>
