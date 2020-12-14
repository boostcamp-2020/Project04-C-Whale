<template>
  <v-list-item
    draggable="true"
    @dragstart="handleDragStart"
    @dragover.prevent="handleDragOver"
    @drop.prevent="handleDrop"
    :class="{ dragging: task.dragging }"
    class="task-item text-subtitle"
  >
    <v-list-item-action>
      <v-checkbox v-model="checkBox" @click="updateTaskStatus"></v-checkbox>
    </v-list-item-action>

    <v-flex class="task-div d-flex" @click.prevent="moveToTaskDetail()">
      <v-list-item-content>
        <v-list-item-title>
          <vue-mark-down
            :class="task.isDone ? 'mark-down text-decoration-line-through' : 'mark-down'"
          >
            {{ task.title }}
          </vue-mark-down>
        </v-list-item-title>
      </v-list-item-content>
    </v-flex>
  </v-list-item>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import { ref } from "@vue/composition-api";
import useDragDropItem from "@/composables/useDragDropItem";
import VueMarkDown from "vue-markdown";
import bus from "@/utils/bus";

export default {
  props: {
    task: Object,
    parentTask: Object,
    section: Object,
    position: Number,
    dragging: Boolean,
  },
  data() {
    return {
      dialog: false,
      checkBox: this.task.isDone,
    };
  },
  components: {
    VueMarkDown,
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
    ...mapMutations(["SET_DRAGGING_TASK", "SET_DROP_TARGET_CONTAINER"]),
    updateTaskStatus() {
      this.updateTaskToDone({
        projectId: this.section.projectId,
        taskId: this.task.id,
        isDone: !this.task.isDone,
      });
    },
    moveToTaskDetail() {
      const destinationInfo = this.$route.params.projectId
        ? {
            name: "ProjectTaskDetail",
            params: { projectId: this.$route.params.projectId, taskId: this.task.id },
          }
        : { name: "TodayTaskDetail", params: { taskId: this.task.id } };
      bus.$emit("moveToTaskDetail", destinationInfo);
    },

    handleDragStart(e) {
      this.SET_DRAGGING_TASK(this.task);
      this.$emit("taskDragStart", { ...this.task, $el: this.$el });
    },

    handleDragOver(e) {
      if (this.task.id === this.draggingTask.id) {
        return;
      }

      if (this.task.parentId) {
        if (this.task.parentId !== this.dropTargetContainer.id) {
          this.SET_DROP_TARGET_CONTAINER({
            ...this.parentTask,
            type: "TASK",
            projectId: this.section.projectId,
          });
        }
      } else {
        if (this.section.id !== this.dropTargetContainer.id) {
          this.SET_DROP_TARGET_CONTAINER({ ...this.section, type: "SECTION" });
        }
      }

      const offset = this.middleY - e.clientY;
      this.$emit("taskDragOver", {
        position: offset > 0 ? this.position : this.position + 1,
      });
    },
    handleDrop() {
      this.$emit("taskDrop");
    },
  },
  computed: {
    ...mapGetters(["draggingTask", "dropTargetContainer"]),
    middleY() {
      const box = this.$el.getBoundingClientRect();
      const middle = box.top + box.height / 2;
      return middle;
    },
  },
  // setup(props, context) {
  //   const { handleDragStart, handleDragOver, handleDrop, taskItem } = useDragDropItem(
  //     props,
  //     context
  //   );
  //   return {
  //     handleDragStart,
  //     handleDragOver,
  //     handleDrop,
  //     taskItem,
  //   };
  // },
};
</script>

<style lang="scss">
.task-item {
  height: 1px;
}

.container {
  min-width: 500px;
}

.done-checkbox {
  border-radius: 100%;
}

.dragging {
  opacity: 0.2;
  background-color: #ededed;
}

.task-div {
  width: 100%;

  &:hover {
    cursor: pointer;
  }
}

.mark-down > p {
  margin: 0;
}
</style>
