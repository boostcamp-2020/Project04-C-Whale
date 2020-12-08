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
                  <v-btn depressed color="normal" v-on="on" width="100" class="mr-3">
                    {{ task.dueDate }}
                  </v-btn>
                </template>
                <v-date-picker v-model="task.dueDate" />
              </v-menu>

              <v-menu :offset-y="true">
                <template v-slot:activator="{ on }">
                  <v-btn depressed color="normal" v-on="on">
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
            </div>
          </div>
          <v-flex>
            <v-btn type="submit" depressed color="primary">+ 작업 추가</v-btn>
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

export default {
  data() {
    return {
      show: false,
      projectTitle: "",
      task: {
        projectId: this.parentProjectId,
        sectionId: this.parentSectionId,
        parentId: this.parentId,
        title: "",
        dueDate: getTodayString(),
      },
    };
  },
  methods: {
    ...mapActions(["addTask"]),
    submit() {
      this.addTask(this.task);
      this.task = {
        projectId: this.section.projectId,
        sectionId: this.section.id,
        parentId: this.parentId,
        title: "",
        dueDate: getTodayString(),
      };
      this.show = !this.show;
    },
    showForm(target) {
      if (target === "url") {
        whale.runtime.sendMessage("ekioepkamjlegkeihddddbcchkdcbihb", "hi", ({ title, url }) => {
          this.task.title = `[${title}](${url})`;
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
      if (this.project) {
        return;
      }
      this.task.projectId = projectInfo.id;
      this.projectTitle = projectInfo.title;
    },
  },
  props: {
    project: Object,
    section: Object,
    projectId: String, 
    sectionId: String, 
    parentId: String,
  },
  computed: {
    ...mapGetters(["projectInfos"]),
    ...mapGetters(["managedProject"]),
  },
  created: function () {
    if (this.project === undefined || this.section === undefined) {
      const { title, id } = this.managedProject;
      this.projectTitle = title;
      this.task.projectId = id;
    }
    this.projectTitle = this.project.title;
    this.task.projectId = this.project.id;
    this.task.sectionId = this.section.id;
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
