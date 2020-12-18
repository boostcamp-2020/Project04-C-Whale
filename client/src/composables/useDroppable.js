import { ref, watch, computed } from "@vue/composition-api";
import store from "../store";

const changeDraggingTaskPosition = (tasks, draggingTask, position) => {
  const newTasks = tasks.filter((task) => {
    return task.id !== draggingTask.id;
  });
  newTasks.splice(position, 0, {
    ...draggingTask,
    dragging: true,
  });
  return newTasks;
};

export default function useDragAndDrop({ parent }) {
  let tasks = ref(parent.value.tasks);
  const draggingTask = computed(() => store.getters.draggingTask);
  const dropTargetContainer = computed(() => store.getters.dropTargetContainer);

  const taskDragOver = ({ position }) => {
    // 자기 자신의 하위작업으로 들어가는 것을 방지
    if (parent.value.id === draggingTask.value.id) {
      return;
    }

    tasks.value = changeDraggingTaskPosition(tasks.value, draggingTask.value, position);
  };

  const taskDrop = () => {
    switch (dropTargetContainer.value.type) {
      case "SECTION":
        store.dispatch("changeTaskPosition", {
          orderedTasks: tasks.value.map((task) => task.id),
        });
        break;
      case "TASK":
        store.dispatch("changeChildTaskPosition", {
          orderedTasks: tasks.value.map((task) => task.id),
        });
        break;
    }
  };

  watch(parent, () => {
    tasks.value = parent.value.tasks;
  });

  watch(dropTargetContainer, () => {
    if (dropTargetContainer.value.id !== parent.value.id) {
      tasks.value = tasks.value.filter((task) => task.id !== draggingTask.value.id);
    }
  });

  return {
    tasks,
    taskDragOver,
    taskDrop,
  };
}
