<template>
  <v-list
    class="mr-10"
    draggable="false"
    @dragstart="sectionDragStart"
    @dragover.prevent="sectionDragOver"
    @drop.prevent="sectionDrop"
  >
    <v-list-item class="font-weight-black text-h6">
      <UpdatableTitle :originalTitle="section.title" :parent="section" type="section" />
    </v-list-item>

    <div
      v-for="(task, index) in showDoneTasks ? tasks : todoTasks"
      :key="task.id"
      class="task-container"
    >
      <TaskItem
        :section="section"
        :task="task"
        :position="index"
        :id="task.id"
        @taskDragOver="taskDragOver"
        @taskDrop="taskDrop"
      />
      <v-divider />
      <div>
        <TaskItem
          v-for="childTask in task.tasks"
          :key="childTask.id"
          :id="childTask.id"
          :task="childTask"
          class="ml-10"
        />
      </div>
    </div>

    <AddTask :projectId="projectId" :sectionId="section.id" />
  </v-list>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import AddTask from "@/components/project/AddTask";
import TaskItem from "@/components/project/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";
import _ from "lodash";
import bus from "@/utils/bus";

export default {
  props: {
    projectId: String,
    section: Object,
    position: Number,
  },
  data: function () {
    return {
      tasks: _.cloneDeep(this.section.tasks),
      showDoneTasks: false,
    };
  },
  methods: {
    ...mapActions(["changeTaskPosition"]),
    ...mapMutations(["SET_DRAGGING_SECTION"]),
    taskDragOver({ position }) {
      this.tasks = this.tasks.filter((task) => task.id !== this.draggingTask.id);
      this.tasks.splice(position, 0, { ...this.draggingTask, dragging: true });
    },
    taskDrop() {
      this.changeTaskPosition({
        orderedTasks: this.tasks.map((task) => task.id),
      });
    },
    sectionDragStart(e) {
      this.SET_DRAGGING_SECTION(this.section);
      e.target.style.display = "none";
    },

    sectionDragOver(e) {
      if (this.section.id === this.draggingSection.id) {
        return;
      }
      const offset = this.middelY - e.clientY;

      this.$emit("sectionDragOver", {
        position: offset > 0 ? this.position : this.position + 1,
      });
    },
    sectionDrop() {
      this.$emit("sectionDrop");
    },
  },
  components: {
    AddTask,
    TaskItem,
    UpdatableTitle,
  },
  computed: {
    ...mapGetters(["draggingTask", "dropTargetSection", "draggingSection"]),
    todoTasks() {
      return this.tasks.filter((task) => !task.isDone);
    },
    middleY() {
      const box = this.$el.getBoundingClientRect();
      const middle = box.top + box.height / 2;
      return middle;
    },
  },
  watch: {
    section(updatedSection) {
      this.tasks = _.cloneDeep(updatedSection.tasks);
    },
    dropTargetSection(dropTargetSection) {
      if (dropTargetSection.id !== this.section.id) {
        this.tasks = this.tasks.filter((task) => task.id !== this.draggingTask.id);
      }
    },
  },
  created() {
    bus.$on("toggleDoneTasks", (showDoneTasks) => {
      this.showDoneTasks = showDoneTasks;
    });
  },
  beforeDestroy() {
    bus.$off("toggleDoneTasks");
  },
};
</script>

<style scoped>
/* .task-container {
  width: 80%;
} */
</style>
