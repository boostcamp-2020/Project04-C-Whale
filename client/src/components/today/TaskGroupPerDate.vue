<template>
  <v-list class="mb-5" v-show="type !== 'expired' || (type === 'expired' && tasks.length > 0)">
    <v-list-item class="font-weight-black text-h6">{{ typeString[type] }}</v-list-item>
    <div v-for="task in tasks" :key="task.id" class="task-container">
      <TaskItem :task="task" />
      <v-divider />
      <div class="childTaskContainer ml-10" v-for="childTask in task.tasks" :key="childTask.id">
        <TaskItem :task="childTask" />
      </div>
    </div>
    <AddTask />
  </v-list>
</template>

<script>
import TaskItem from "@/components/project/TaskItem";
import AddTask from "@/components/project/AddTask";

export default {
  props: {
    tasks: Array,
    type: String,
  },
  data() {
    return {
      typeString: {
        expired: "기한이 지난",
        today: "오늘",
      },
    };
  },
  components: { TaskItem, AddTask },
};
</script>
