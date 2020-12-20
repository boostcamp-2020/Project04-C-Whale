<template>
  <v-hover v-slot="{ hover }">
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
        <v-list-item-content class="d-flex">
          <v-list-item-title class="d-flex">
            <vue-mark-down
              :class="task.isDone ? 'mark-down text-decoration-line-through' : 'mark-down'"
            >
              {{ task.title }}
            </vue-mark-down>
            <span
              v-if="showDate === undefined ? true : showDate"
              class="d-inline-block font-10 ml-3 align-self-end primary--text"
            >
              {{ dateString }}
            </span>
            <span v-if="task.section" class="d-inline-block font-12 ml-3 align-self-end">
              <v-icon x-small :color="task.section.project.color">mdi-circle</v-icon>
              {{ task.section.project.title }}
            </span>
          </v-list-item-title>
        </v-list-item-content>
      </v-flex>

      <v-list-item-action @click="confirmDeleteTask" :class="{ noHover: !hover }">
        <v-btn icon>
          <v-icon color="grey lighten-1">mdi-trash-can</v-icon>
        </v-btn>
      </v-list-item-action>
    </v-list-item>
  </v-hover>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import VueMarkDown from "vue-markdown";
import bus from "@/utils/bus";

export default {
  components: {
    VueMarkDown,
  },
  props: {
    task: Object,
    parentTask: Object,
    section: Object,
    position: Number,
    dragging: Boolean,
    showDate: Boolean,
  },
  data() {
    return {
      dialog: false,
      checkBox: this.task.isDone,
    };
  },
  computed: {
    ...mapGetters(["draggingTask", "dropTargetContainer"]),
    middleY() {
      const box = this.$el.getBoundingClientRect();
      const middle = box.top + box.height / 2;
      return middle;
    },
    dateString() {
      return new Date(this.task.dueDate).toLocaleDateString();
    },
  },
  methods: {
    ...mapActions(["updateTaskToDone", "deleteTask"]),
    ...mapMutations(["SET_DRAGGING_TASK", "SET_DROP_TARGET_CONTAINER"]),
    updateTaskStatus() {
      this.updateTaskToDone({
        projectId: this.section.projectId,
        taskId: this.task.id,
        isDone: !this.task.isDone,
      });
    },
    confirmDeleteTask() {
      if (window.confirm("삭제하시겠습니까?")) {
        this.deleteTask({
          task: { ...this.task, projectId: this.section.projectId },
        });
      }
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
    handleDragStart() {
      this.SET_DRAGGING_TASK(this.task);
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

.font-10 {
  font-size: 10px;
}

.flex-initial {
  flex: initial !important;
}

.noHover {
  display: none !important;
}
</style>
