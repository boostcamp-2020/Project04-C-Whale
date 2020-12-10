<template>
  <div class="project-container">
    <TaskGroupPerDate :tasks="expiredTasks" type="expired" />
    <TaskGroupPerDate :tasks="todayTasks" type="today" />
    <div v-show="isEmpty">
      <p class="text-center">오늘의 작업이 없습니다! 좋은 하루 되세요</p>
      <v-img src="@/assets/halgoraedo.png"></v-img>
    </div>
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
  computed: {
    isEmpty() {
      return this.expiredTasks.length === 0 && this.todayTasks.length === 0;
    },
  },
  components: { TaskGroupPerDate },
};
</script>
