<template>
  <div class="project-container">
    <v-list class="mb-5" v-if="expiredTasks.length > 0">
      <v-list-item class="font-weight-black text-h6"> 기한이 지난 </v-list-item>

      <div v-for="task in expiredTasks" :key="task.id" class="task-container">
        <task-item :task="task" />

        <v-divider />

        <div class="childTaskContainer ml-10" v-for="childTask in task.tasks" :key="childTask.id">
          <task-item :task="childTask" />
        </div>
      </div>
      <!-- <AddTask :projectId="managedProject.id" /> -->
      <!-- <add-task :projectId="section.projectId" :sectionId="section.id" /> -->
    </v-list>
    <v-list class="mb-5">
      <v-list-item class="font-weight-black text-h6"> 오늘 </v-list-item>

      <div v-for="task in todayTasks" :key="task.id" class="task-container">
        <task-item :task="task" />

        <v-divider />

        <div class="childTaskContainer ml-10" v-for="childTask in task.tasks" :key="childTask.id">
          <task-item :task="childTask" />
        </div>
      </div>
      <!-- <AddTask :projectId="managedProject.id" /> -->

      <!-- <add-task :projectId="section.projectId" :sectionId="section.id" /> -->
    </v-list>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import TaskItem from "@/components/project/TaskItem";
import AddTask from "@/components/project/AddTask";

export default {
  props: {
    todayTasks: Array,
    expiredTasks: Array,
  },
  data() {
    return {};
  },
  computed: {
    ...mapGetters(["managedProject"]),
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
  },
  components: { TaskItem, AddTask },
};
</script>
