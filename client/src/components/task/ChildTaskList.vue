<template>
  <div>
    <TaskItem
      v-for="(childTask, index) in tasks"
      :key="childTask.id"
      :section="section"
      :parentTask="parentTask"
      :task="childTask"
      :position="index"
      @taskDragOver="taskDragOver"
      @taskDrop="taskDrop"
    />
  </div>
</template>

<script>
import TaskItem from "@/components/task/TaskItem";

import { toRefs } from "@vue/composition-api";
import useDragDropContainer from "@/composables/useDroppable";

export default {
  components: {
    TaskItem,
  },
  props: {
    projectId: String,
    section: Object,
    parentTask: Object,
  },
  setup(props) {
    const { parentTask } = toRefs(props);
    const { tasks, taskDragOver, taskDrop } = useDragDropContainer({ parent: parentTask });

    return {
      tasks,
      taskDragOver,
      taskDrop,
    };
  },
};
</script>
