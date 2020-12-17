<template>
  <v-list class="mr-10" draggable="false">
    <v-list-item class="font-weight-black text-h6">
      <UpdatableTitle :originalTitle="section.title" :parent="section" type="section" />
    </v-list-item>

    <div v-for="(task, index) in tasks" :key="task.id" class="task-container">
      <TaskItem
        v-if="shouldShow(task)"
        :section="section"
        :task="task"
        :position="index"
        :id="task.id"
        @taskDragOver="taskDragOver"
        @taskDrop="taskDrop"
      />
      <v-divider v-if="shouldShow(task)" />
      <ChildTaskList v-if="task.tasks" :section="section" :parentTask="task" class="ml-10" />
    </div>

    <AddTask :projectId="projectId" :sectionId="section.id" />
  </v-list>
</template>

<script>
import AddTask from "@/components/task/AddTask";
import TaskItem from "@/components/task/TaskItem";
import UpdatableTitle from "@/components/common/UpdatableTitle";
import ChildTaskList from "@/components/task/ChildTaskList";
import { toRefs } from "@vue/composition-api";
import useDroppable from "@/composables/useDroppable";
import bus from "@/utils/bus";
import { mapGetters } from "vuex";

export default {
  components: {
    AddTask,
    TaskItem,
    UpdatableTitle,
    ChildTaskList,
  },
  props: {
    projectId: String,
    section: Object,
    position: Number,
  },
  data() {
    return {
      showDoneTasks: false,
    };
  },
  computed: {
    ...mapGetters(["draggingSection"]),
    todoTasks() {
      return this.tasks.filter((task) => !task.isDone);
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
  setup(props) {
    const { section } = toRefs(props);
    const { tasks, taskDragOver, taskDrop } = useDroppable({ parent: section });

    return {
      tasks,
      taskDragOver,
      taskDrop,
    };
  },
  methods: {
    shouldShow(task) {
      if (this.showDoneTasks) {
        return true;
      }
      return task.isDone ? false : true;
    },
  },
};
</script>
