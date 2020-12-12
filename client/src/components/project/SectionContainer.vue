<template>
  <v-list class="mr-10">
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
        @taskDragOver="taskDragOver"
        @taskDrop="taskDrop"
      />
      <v-divider />
      <div>
        <TaskItem
          v-for="childTask in task.tasks"
          :key="childTask.id"
          :task="childTask"
          class="ml-10"
        />
      </div>
    </div>

    <AddTask :projectId="projectId" :sectionId="section.id" />
  </v-list>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import AddTask from "@/components/project/AddTask";
import TaskItem from "@/components/project/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";
import _ from "lodash";
import bus from "@/utils/bus";

export default {
  props: {
    projectId: String,
    section: Object,
  },
  data: function () {
    return {
      tasks: _.cloneDeep(this.section.tasks),
      showDoneTasks: false,
    };
  },
  methods: {
    ...mapActions(["changeTaskPosition"]),
    taskDragOver({ position }) {
      this.tasks = this.tasks.filter((task) => task.id !== this.draggingTask.id);
      this.tasks.splice(position, 0, { ...this.draggingTask, dragging: true });
    },
    taskDrop() {
      this.changeTaskPosition({
        orderedTasks: this.tasks.map((task) => task.id),
      });
    },
  },
  components: {
    AddTask,
    TaskItem,
    UpdatableTitle,
  },
  computed: {
    ...mapGetters(["draggingTask", "dropTargetSection"]),
    todoTasks() {
      return this.tasks.filter((task) => !task.isDone);
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
.task-container {
  min-width: 450px;
}
</style>
