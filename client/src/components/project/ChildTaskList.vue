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
import TaskItem from "@/components/project/TaskItem";

import { toRefs } from "@vue/composition-api";
import useDragDropContainer from "@/composables/useDragDropContainer";

export default {
  props: {
    projectId: String,
    section: Object,
    parentTask: Object,
  },
  components: {
    TaskItem,
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
