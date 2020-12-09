<template>
  <div class="project-container">
    <TaskGroupPerDate :tasks="expiredTasks" type="expired" />
    <TaskGroupPerDate :tasks="todayTasks" type="today" />
  </div>
</template>

<script>
import TaskGroupPerDate from "@/components/today/TaskGroupPerDate";

export default {
  props: {
    todayTasks: Array,
    expiredTasks: Array,
  },
  data() {
    return {};
  },
  components: { TaskGroupPerDate },
};
</script>
