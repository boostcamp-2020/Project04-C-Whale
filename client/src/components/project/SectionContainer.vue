<template>
  <v-list class="mr-10">
    <v-list-item class="font-weight-black text-h6">
      <UpdatableTitle :originalTitle="section.title" :parent="section" type="section" />
    </v-list-item>

    <div v-for="(task, index) in tasks" :key="task.id" class="task-container">
      <TaskItem
        :section="section"
        :task="task"
        :position="index"
        @taskDragOver="taskDragOver"
        @taskDrop="taskDrop"
      />
      <v-divider />
      <TaskItem
        v-for="childTask in task.tasks"
        :key="childTask.id"
        :task="childTask"
        class="ml-10"
      />
    </div>

    <AddTask :project="project" :section="section" />
  </v-list>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import AddTask from "@/components/project/AddTask";
import TaskItem from "@/components/project/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";
import _ from "lodash";

export default {
  props: {
    project: Object,
    section: Object,
  },
  data: function () {
    return {
      tasks: _.cloneDeep(this.section.tasks),
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
  },
  watch: {
    section: function (updatedSection) {
      this.tasks = _.cloneDeep(updatedSection.tasks);
    },
    dropTargetSection: function (dropTargetSection) {
      if (dropTargetSection.id !== this.section.id) {
        this.tasks = this.tasks.filter((task) => task.id !== this.draggingTask.id);
      }
    },
  },
};
</script>

<style scoped>
.task-container {
  min-width: 450px;
}
</style>
