<template>
  <div class="project-container">
    <TaskGroupPerDate key="expired" :tasks="expiredTasks" type="expired" />
    <TaskGroupPerDate key="today" :tasks="todayTasks" type="today" />
    <div v-show="isEmpty">
      <p class="text-center">오늘의 작업이 없습니다! 좋은 하루 되세요</p>
      <v-img src="@/assets/halgoraedo.png"></v-img>
    </div>
    <keep-alive>
      <router-view :key="$route.params.taskId"></router-view>
    </keep-alive>
  </div>
</template>

<script>
import TaskGroupPerDate from "@/components/today/TaskGroupPerDate";
import bus from "@/utils/bus";

export default {
  props: {
    todayTasks: Array,
    expiredTasks: Array,
  },
  components: { TaskGroupPerDate },
  data() {
    return {};
  },
  computed: {
    isEmpty() {
      return this.expiredTasks.length === 0 && this.todayTasks.length === 0;
    },
  },
  created() {
    bus.$on("moveToTaskDetail", (destinationInfo) => {
      this.$router.push(destinationInfo).catch(() => {});
    });
  },
};
</script>
