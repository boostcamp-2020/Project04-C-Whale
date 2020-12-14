<template>
  <v-list class="mr-10">
    <v-list-item class="font-weight-black text-h6">
      <UpdatableTitle :originalTitle="section.title" :parent="section" type="section" />
    </v-list-item>

    <div v-for="(task, index) in tasks" :key="task.id" class="task-container">
      <div v-if="!task.isDone">
        <TaskItem
          :section="section"
          :task="task"
          :position="index"
          @taskDragOver="taskDragOver"
          @taskDrop="taskDrop"
        />
        <v-divider />

        <ChildTaskList v-if="task.tasks" :section="section" :parentTask="task" class="ml-10" />
      </div>
    </div>

    <AddTask :projectId="projectId" :sectionId="section.id" />
  </v-list>
</template>

<script>
import AddTask from "@/components/project/AddTask";
import TaskItem from "@/components/project/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";
import ChildTaskList from "@/components/project/ChildTaskList";
import { toRefs } from "@vue/composition-api";
import useDragDropContainer from "@/composables/useDragDropContainer";

export default {
  props: {
    projectId: String,
    section: Object,
  },
  components: {
    AddTask,
    TaskItem,
    UpdatableTitle,
    ChildTaskList,
  },
  setup(props) {
    const { section } = toRefs(props);
    const { tasks, taskDragOver, taskDrop } = useDragDropContainer({ parent: section });

    return {
      tasks,
      taskDragOver,
      taskDrop,
    };
  },
};
</script>

<style scoped>
.task-container {
  min-width: 450px;
}
</style>
