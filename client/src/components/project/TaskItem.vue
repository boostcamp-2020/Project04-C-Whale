<template>
  <v-list-item
    draggable="true"
    @dragstart="handleDragStart"
    @dragend="handleDragEnd"
    @dragover.prevent="handleDragOver"
    @dragleave="handleDragLeave"
    @drop.prevent="handleDrop"
    :class="{ dragging, draggedOver }"
  >
    <v-list-item-action>
      <v-radio-group>
        <v-radio
          dense
          @click="updateTaskToDone({ projectId: task.projectId, taskId: task.id })"
          class="done-checkbox"
        ></v-radio>
      </v-radio-group>
    </v-list-item-action>

    <v-list-item-content class="task-title-container">
      <v-list-item-title>{{ task.title }}</v-list-item-title>
    </v-list-item-content>
  </v-list-item>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      dragging: false,
      draggedOver: false,
    };
  },
  methods: {
    ...mapActions(["updateTaskToDone", "startDragTask", "changeTaskPosition"]),
    handleDragStart() {
      this.dragging = true;
      this.startDragTask({
        task: {
          ...this.task,
          position: this.position,
        },
      });
    },
    handleDragEnd() {
      this.dragging = false;
    },
    handleDragOver() {
      this.draggedOver = true;

      // const offset = this.middleY - e.clientY;
      // if (offset < 0) {
      //   this.changeTaskPosition({
      //     targetSection: this.section,
      //     task: this.task,
      //     position: this.position + 1,
      //   });
      // }
    },
    handleDragLeave() {
      this.draggedOver = false;
    },
    handleDrop() {
      this.changeTaskPosition({
        section: this.section,
        task: this.task,
      });
      this.draggedOver = false;
    },
  },
  computed: {
    ...mapGetters(["draggingTask"]),
    middleY() {
      const box = this.$el.getBoundingClientRect();
      const middle = box.top + box.height / 2;
      return middle;
    },
  },
  props: ["section", "task", "position"],
};
</script>

<style>
.container {
  min-width: 500px;
}

.done-checkbox {
  border-radius: 100%;
}

.done-checkbox:hover {
  border-radius: 50%;
}

.dragging {
  opacity: 0.3;
}

.draggedOver {
  border-bottom: 2px solid blue !important;
}
</style>
