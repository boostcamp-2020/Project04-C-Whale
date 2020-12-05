<template>
  <v-list>
    <v-list-item class="font-weight-black text-h6">
      <UpdatableTitle :originalTitle="section.title" :parent="section" type="section" />
    </v-list-item>

    <div v-for="(task, index) in tasks" :key="task.id" class="task-container">
      <TaskItem
        :section="section"
        :task="task"
        :position="index"
        v-on="$listeners"
        @taskDragOver="taskDragOver"
      />
      <v-divider />
      <TaskItem
        v-for="childTask in task.tasks"
        :key="childTask.id"
        :task="childTask"
        class="ml-10"
      />
    </div>

    <AddTask :projectId="section.projectId" :sectionId="section.id" />
  </v-list>
</template>

<script>
import AddTask from "@/components/project/AddTask";
import TaskItem from "@/components/project/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";
import _ from "lodash";

export default {
  props: {
    section: Object,
    draggingTask: Object,
  },
  data: function () {
    return {
      tasks: _.cloneDeep(this.section.tasks),
    };
  },
  methods: {
    taskDragOver(position) {
      this.tasks.splice(position, 0, this.draggingTask);
    },
  },
  components: {
    AddTask,
    TaskItem,
    UpdatableTitle,
  },
  watch: {
    section: function (updatedSection) {
      this.tasks = _.cloneDeep(updatedSection.tasks);
    },
  },
};
</script>

<style>
.task-container {
  min-width: 450px;
}
</style>
