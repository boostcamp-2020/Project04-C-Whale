<template>
  <v-list class="mb-5" v-show="type !== 'expired' || (type === 'expired' && tasks.length > 0)">
    <v-list-item class="font-weight-black text-h6"
      >{{ typeString[type] }}
      <!--TODO: 기한이 지난 날짜 없애기 -->
      <span v-show="type === 'today'" class="font-14 d-inline-block ml-2">{{ todayString }}</span>
    </v-list-item>
    <div v-for="task in tasks" :key="task.id" class="task-container">
      <TaskItem :task="task" />
      <v-divider />
      <div>
        <TaskItem
          v-for="childTask in task.tasks"
          :key="childTask.id"
          :id="childTask.id"
          :task="childTask"
          class="ml-10"
        />
      </div>
    </div>
    <AddTask 
      :projectId="managedProject.id" 
      :sectionId="managedProject.defaultSectionId"
    />
  </v-list>
</template>

<script>
import { mapGetters } from 'vuex';
import TaskItem from "@/components/project/TaskItem";
import AddTask from "@/components/project/AddTask";
import { getTodayString } from "@/utils/date";

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
  computed: {
    ...mapGetters(['managedProject']),
    todayString() {
      return getTodayString();
    },
  },
  components: { TaskItem, AddTask },
};
</script>
