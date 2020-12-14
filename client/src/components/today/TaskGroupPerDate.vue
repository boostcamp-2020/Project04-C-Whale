<template>
  <div v-if="tasks.length > 0">
    <v-list class="mb-5" v-show="type !== 'expired' || (type === 'expired' && tasks.length > 0)">
      <v-list-item class="font-weight-black text-h6"
        >{{ typeString[type] }}
        <span v-if="isToday" class="font-14 d-inline-block ml-2">{{ todayString }}</span>
      </v-list-item>

      <div v-for="task in tasks" :key="task.id" class="task-container">
        <TaskItem :section="task.section" :task="task" :id="task.id" />
        <v-divider />
        <ChildTaskList v-if="task.tasks" :section="task.section" :parentTask="task" class="ml-10" />
      </div>

      <AddTask
        v-if="isToday"
        v-show="managedProject"
        :projectId="managedProject.id"
        :sectionId="managedProject.defaultSectionId"
      />
    </v-list>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import TaskItem from "@/components/project/TaskItem";
import AddTask from "@/components/project/AddTask";
import ChildTaskList from "@/components/project/ChildTaskList";
import { getTodayString } from "@/utils/date";

export default {
  components: { TaskItem, AddTask, ChildTaskList },
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
    ...mapGetters(["managedProject"]),
    todayString() {
      return getTodayString();
    },
    isToday() {
      return this.type === "today";
    },
  },
};
</script>
