<template>
  <v-list-item>
    <div v-if="show" class="task-form-container">
      <form @submit.prevent="submit">
        <div class="task-form-data">
          <v-text-field
            class="pt-0 mt-0 mb-2"
            hide-details
            type="text"
            v-model="task.title"
            placeholder="할일을 입력하세요"
          />

          <div class="task-info">
            <AddTaskDueDatePicker v-model="task.dueDate" />
            <AddTaskProjectPicker @pickProject="pickProject" :projectId="task.projectId" />
            <AddTaskAlarmPicker v-model="this.alarmTime" />
          </div>
        </div>

        <AddTaskButtonContainerAfter :task="task" @closeForm="closeForm" />
      </form>
    </div>

    <AddTaskButtonContainerBefore v-else @showForm="showForm" @getUrl="getUrl" />
  </v-list-item>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import AddTaskButtonContainerBefore from "@/components/task/AddTaskButtonContainerBefore";
import AddTaskButtonContainerAfter from "@/components/task/AddTaskButtonContainerAfter";
import AddTaskDueDatePicker from "@/components/task/AddTaskDueDatePicker";
import AddTaskProjectPicker from "@/components/task/AddTaskProjectPicker";
import AddTaskAlarmPicker from "@/components/task/AddTaskAlarmPicker";
import whaleApi from "@/utils/whaleApi";
import { getTodayString } from "@/utils/date";
import { getMarkDownUrl } from "@/utils/markdown";

export default {
  props: {
    projectId: String,
    sectionId: String,
    parentId: String,
    initialShow: Boolean,
    type: String,
  },
  components: {
    AddTaskButtonContainerBefore,
    AddTaskButtonContainerAfter,
    AddTaskDueDatePicker,
    AddTaskProjectPicker,
    AddTaskAlarmPicker,
  },
  data() {
    return {
      show: this.initialShow || false,
      task: {
        projectId: this.projectId,
        sectionId: this.sectionId,
        parentId: this.parentId || null,
        title: "",
        dueDate: getTodayString(),
      },
      alarmTime: {
        HH: "00",
        mm: "00",
        ss: "00",
      },
    };
  },
  computed: {
    ...mapGetters(["projectInfos", "managedProject"]),
  },
  created() {
    if (this.projectId === undefined || this.sectionId === undefined) {
      this.task.projectId = this.managedProject?.id;
      this.task.sectionId = this.managedProject?.defaultSectionId;
      return;
    }

    this.task.projectId = this.projectId;
    this.task.sectionId = this.sectionId;
  },
  methods: {
    ...mapActions(["addTask"]),

    showForm() {
      this.show = !this.show;
    },
    closeForm() {
      this.task.title = "";

      if (this.type === "quick") {
        this.$emit("done");
        return;
      }
      this.show = !this.show;
    },

    submit() {
      this.addTask(this.task);
      this.submitAlarm();

      this.task = {
        projectId: this.projectId ? this.projectId : this.managedProject.id,
        sectionId: this.sectionId ? this.sectionId : this.managedProject.defaultSectionId,
        parentId: this.parentId || null,
        title: "",
        dueDate: getTodayString(),
      };

      if (this.type === "quick") {
        this.$emit("done");
        return;
      }
      this.show = !this.show;
    },

    submitAlarm() {
      if (this.getAlarmTimeInSec() <= Date.now()) {
        return;
      }

      whaleApi.createAlarm({
        taskTitle: this.task.title,
        fireTime: this.getAlarmTimeInSec(),
      });

      this.alarmTime = {
        HH: "00",
        mm: "00",
        ss: "00",
      };
    },

    getAlarmTimeInSec() {
      return (
        Date.now() + (this.alarmTime.HH * 3600 + this.alarmTime.mm * 60 + this.alarmTime.ss) * 1000
      );
    },

    pickProject(projectInfo) {
      this.task.projectId = projectInfo.id;
      this.task.sectionId = projectInfo.defaultSectionId;
    },

    getUrl() {
      whaleApi.getCurrentTabUrl(({ title, url }) => {
        this.task.title = getMarkDownUrl(title, url);
      });
    },
  },
};
</script>

<style scoped>
.task-form-container {
  width: 100%;
}

.task-form-data {
  display: flex;
  flex-direction: column;
  border: 1px solid #ddd;
  min-width: 440px;
  padding: 15px;
  border-radius: 5px;
  margin-top: 10px;
  margin-bottom: 10px;
}

input:focus {
  outline: none;
}
</style>
