<template>
  <div>
    <task-item v-for="childTask in tasks" :key="childTask.id" :task="childTask" />
    <div>프로젝트 : {{ projectId }} 부모: {{ parentId }} 섹션: {{ sectionId }}</div>
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
  components: { TaskItem, AddTask },
};
</script>
<style></style>
