import { ref, watch, computed, onMounted } from "@vue/composition-api";
import store from "../store";

export default function useDragAndDropItem({ task, parentTask, section, position }, context) {
  const draggingTask = computed(() => store.getters.draggingTask);
  const dropTargetContainer = computed(() => store.getters.dropTargetContainer);
  // const middleY = computed(() => {
  //   const box = taskItem.value.$el.getBoundingClientRect();
  //   const middle = box.top + box.height / 2;
  //   return middle;
  // });
  const handleDragStart = () => {
    store.commit("SET_DRAGGING_TASK", task);
  };

  const handleDragOver = (e) => {
    if (task.id === draggingTask.value.id) {
      return;
    }

    if (task.parentId) {
      if (task.parentId !== dropTargetContainer.value.id) {
        store.commit("SET_DROP_TARGET_CONTAINER", {
          ...parentTask,
          type: "TASK",
          projectId: section.projectId,
        });
      }
    } else {
      if (section.id !== dropTargetContainer.value.id) {
        store.commit("SET_DROP_TARGET_CONTAINER", { ...section, type: "SECTION" });
      }
    }

    const offset = middleY.value - e.clientY;
    // console.log(position + 1);
    // console.log(position);
    context.emit("taskDragOver", {
      position: offset > 0 ? position : position + 1,
    });
  };

  const handleDrop = () => {
    context.emit("taskDrop");
  };

  return {
    handleDragStart,
    handleDragOver,
    handleDrop,
    taskItem,
    draggingTask,
    dropTargetContainer,
    middleY,
  };
}
