<template>
  <div>
    <task-item v-for="childTask in opendTasks" :key="childTask.id" :task="childTask" />
    <add-task :projectId="projectId" :parentId="parentId" :sectionId="sectionId" />
  </div>
</template>

<script>
import TaskItem from "@/components/project/TaskItem";
import AddTask from "@/components/project/AddTask";

export default {
  props: {
    tasks: Array,
    projectId: String,
    sectionId: String,
    parentId: String,
  },
  computed: {
    opendTasks() {
      return this.tasks.filter((task) => !task.isDone);
    },
  },
  components: { TaskItem, AddTask },
};
</script>
<style></style>
