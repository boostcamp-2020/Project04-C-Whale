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
      <v-radio-group>
        <v-radio
          dense
          @click="updateTaskToDone({ projectId: task.projectId, taskId: task.id })"
          class="done-checkbox"
        ></v-radio>
      </v-radio-group>
    </v-list-item-action>

    <div class="task-div" @click="moveToTaskDetail()">
      <v-list-item-content>
        <v-list-item-title>
          <vue-markdown class="mark-down">
            {{ task.title }}
          </vue-markdown>
        </v-list-item-title>
      </v-list-item-content>
    </div>
    <router-view :key="$route.params.taskId" />
  </v-list-item>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import VueMarkDown from "vue-markdown";

export default {
  props: {
    task: Object,
    section: Object,
    position: Number,
    dragging: Boolean,
  },
  components: {
    "vue-markdown": VueMarkDown,
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
    ...mapMutations(["SET_DRAGGING_TASK", "SET_DROP_TARGET_SECTION"]),

    moveToTaskDetail() {
      const destinationInfo = this.$route.params.projectId
        ? {
            name: "ProjectTaskDetail",
            params: { projectId: this.task.projectId, taskId: this.task.id },
          }
        : { name: "TodayTaskDetail", params: { taskId: this.task.id } };

      this.$router.push(destinationInfo).catch(() => {});
    },

    handleDragStart() {
      this.SET_DRAGGING_TASK(this.task);
      this.$emit("taskDragStart", { ...this.task, $el: this.$el });
    },

    handleDragOver(e) {
      if (this.task.id === this.draggingTask.id) {
        return;
      }

      this.SET_DROP_TARGET_SECTION(this.section);

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
    ...mapGetters(["draggingTask"]),
    middleY() {
      const box = this.$el.getBoundingClientRect();
      const middle = box.top + box.height / 2;
      return middle;
    },
  },
};
</script>

<style>
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
}
.task-div:hover {
  /* border-radius: 10px; */
  cursor: pointer;
  /* background-color: #1c2b82;
  color: white;
  padding-left: 10px; */
}
</style>
