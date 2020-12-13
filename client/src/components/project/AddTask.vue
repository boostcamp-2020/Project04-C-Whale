<template>
  <v-list-item>
    <v-layout row wrap>
      <div v-if="show" class="task-form-container">
        <form @submit.prevent="submit">
          <div class="task-form-data">
            <input type="text" v-model="task.title" placeholder="할일을 입력하세요" />
            <div class="task-info">
              <v-menu :offset-y="true">
                <template v-slot:activator="{ on }">
                  <v-btn depressed color="normal" v-on="on" width="120" class="mr-3">
                    기한:{{ todayStringToKorean(task.dueDate) }}
                  </v-btn>
                </template>
                <v-date-picker v-model="task.dueDate" />
              </v-menu>

              <v-menu :offset-y="true">
                <template v-slot:activator="{ on }">
                  <v-btn depressed color="normal" v-on="on" class="mr-3">
                    <v-icon color="blue">mdi-inbox</v-icon>
                    {{ projectTitle }}
                  </v-btn>
                </template>
                <v-list>
                  <v-list-item
                    v-for="projectInfo in projectInfos"
                    :key="projectInfo.id"
                    @click="selectProject(projectInfo)"
                  >
                    <v-list-item-icon>
                      <v-icon color="blue">mdi-inbox</v-icon>
                    </v-list-item-icon>
                    <v-list-item-title>{{ projectInfo.title }}</v-list-item-title>
                  </v-list-item>
                </v-list>
              </v-menu>

              <v-menu :offset-y="true">
                <template v-slot:activator="{ on }">
                  <v-btn depressed color="normal" v-on="on">
                    <v-icon color="red">mdi-alarm</v-icon>
                    알람:
                  </v-btn>
                </template>
                <v-list>
                  <v-list-item @click="selectAlarm(5)">
                    <v-list-item-title>5초 후</v-list-item-title>
                  </v-list-item>
                  <v-list-item>
                    <v-list-item-title>10초 후</v-list-item-title>
                  </v-list-item>
                </v-list>
              </v-menu>
            </div>
          </div>
          <v-flex>
            <v-btn type="submit" depressed color="primary" :disabled="task.title.length === 0"
              >+ 작업 추가</v-btn
            >
            <v-btn @click="closeForm" text color="primary">취소</v-btn>
          </v-flex>
        </form>
      </div>

      <div v-else class="add-button-container">
        <v-btn @click="showForm" text color="#777777">
          <v-icon color="primary" dense class="mr-1"> mdi-plus </v-icon>
          작업 추가
        </v-btn>
        <v-btn @click="showForm('url')" text color="#777777">
          <v-icon color="primary" dense class="mr-1"> mdi-plus </v-icon>
          웹사이트를 작업으로 추가
        </v-btn>
      </div>
    </v-layout>
  </v-list-item>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import { getTodayString } from "../../utils/date";
import whaleApi from "../../utils/whaleApi";
import { getMarkDownUrl } from "../../utils/markdown";
import { createAlarm } from "../../utils/whaleApi";

export default {
  props: {
    projectId: String,
    sectionId: String,
    parentId: String,
    initialShow: Boolean,
  },
  data() {
    return {
      show: this.initialShow || false,
      projectTitle: "",
      task: {
        projectId: this.projectId,
        sectionId: this.sectionId,
        parentId: this.parentId || null,
        title: "",
        dueDate: getTodayString(),
      },
      alarmTime: 0,
    };
  },
  computed: {
    ...mapGetters(["projectInfos", "managedProject"]),
  },
  methods: {
    ...mapActions(["addTask"]),
    submit() {
      // 오늘 페이지 첫 렌더링 시, projectId, sectionId가 없는 상황을 위한 초기화
      // this.task.projectId = this.projectId ? this.projectId : this.managedProject.id;
      // this.sectionId = this.sectionId ? this.sectionId : this.managedProject.defaultSectionId;
      this.addTask(this.task);
      whaleApi.createAlarm({
        taskId: '??',
        taskTitle: this.task.title,
        fireTime: this.alarmTime,
      });
      this.task = {
        projectId: this.projectId ? this.projectId : this.managedProject.id,
        sectionId: this.sectionId ? this.sectionId : this.managedProject.defaultSectionId,
        parentId: this.parentId || null,
        title: "",
        dueDate: getTodayString(),
      };

      this.projectTitle = this.managedProject.title;
      this.show = !this.show;
    },
    showForm(target) {
      if (target === "url") {
        whaleApi.getCurrentTabUrl(({ title, url }) => {
          this.task.title = getMarkDownUrl(title, url);
        });
      }
      this.show = !this.show;
    },
    closeForm() {
      this.task.title = "";
      this.show = !this.show;
    },
    selectProject(projectInfo) {
      // TO DO : 에러 처리
      this.task.projectId = projectInfo.id;
      this.task.sectionId = projectInfo.defaultSectionId;
      this.projectTitle = projectInfo.title;
    },
    todayStringToKorean(todayString) {
      const today = new Date(todayString);
      return `${today.getMonth()}월 ${today.getDate()}일`;
    },
    selectAlarm(time) {
      this.alarmTime = Date.now() + 1000 * time;
    },
  },
  created() {
    if (this.projectId === undefined || this.sectionId === undefined) {
      const { title, id, defaultSectionId } = this.managedProject;
      this.projectTitle = title;
      this.task.projectId = id;
      this.task.sectionId = defaultSectionId;
      return;
    }
    this.projectTitle = this.projectInfos.find((project) => project.id === this.projectId).title;
    this.task.projectId = this.projectId;
    this.task.sectionId = this.sectionId;
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
.add-button-container {
  display: flex;
  margin-top: 6px;
}
input[type="text"] {
  margin-bottom: 10px;
}
input:focus {
  outline: none;
}
</style>
