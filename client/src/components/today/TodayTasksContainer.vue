<template>
  <div class="project-container">
    <TaskGroupPerDate key="expired" :tasks="expiredTasks" type="expired" />
    <TaskGroupPerDate key="today" :tasks="todayTasks" type="today" />
    <div v-show="isEmpty">
      <p class="text-center">오늘의 작업이 없습니다! 좋은 하루 되세요</p>
      <v-img src="@/assets/halgoraedo.png"></v-img>
      <AddTask
        v-if="managedProject"
        :projectId="managedProject.id"
        :sectionId="managedProject.defaultSectionId"
      />
    </div>
    <keep-alive>
      <router-view :key="$route.params.taskId"></router-view>
    </keep-alive>
  </div>
</template>

<script>
import TaskGroupPerDate from "@/components/today/TaskGroupPerDate";
import AddTask from "@/components/task/AddTask";
import bus from "@/utils/bus";
import { mapGetters } from "vuex";

export default {
  components: { TaskGroupPerDate, AddTask },
  props: {
    todayTasks: Array,
    expiredTasks: Array,
  },
  data() {
    return {};
  },
  computed: {
    ...mapGetters(["managedProject"]),
    isEmpty() {
      return this.expiredTasks.length === 0 && this.todayTasks.length === 0;
    },
  },
  created() {
    bus.$on("moveToTaskDetail", (destinationInfo) => {
      this.$router.push(destinationInfo).catch(() => {});
    });
  },
  beforeDestroy() {
    bus.$off("moveToTaskDetail");
  },
};
</script>
