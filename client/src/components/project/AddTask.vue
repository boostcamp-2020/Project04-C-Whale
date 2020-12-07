<template>
  <v-list-item>
    <v-layout row wrap>
      <div v-if="show" class="task-form-container">
        <form @submit.prevent="submit">
          <div class="task-form-data">
            <input type="text" v-model="task.title" placeholder="할일을 입력하세요" />
            <v-menu :offset-y="true">
              <template v-slot:activator="{ on }">
                <v-btn depressed color="normal" v-on="on" width="100">
                  {{ task.dueDate }}
                </v-btn>
              </template>
              <v-list>
                <v-list-item v-for="date in defaultDates" :key="date">
                  {{ date }}
                </v-list-item>
              </v-list>
              <v-date-picker v-model="task.dueDate" />
            </v-menu>
          </div>
          <v-flex>
            <v-btn type="submit" depressed color="primary">+ 작업 추가</v-btn>
            <v-btn @click="closeForm" text color="primary">취소</v-btn>
          </v-flex>
        </form>
      </div>
      <div v-if="!show" class="add-button-container">
        <v-btn @click="showForm" text color="primary"> + 작업 추가 </v-btn>
        <v-btn @click="showForm('url')" text color="primary"> + 웹사이트를 작업으로 추가 </v-btn>
      </div>
    </v-layout>
  </v-list-item>
</template>

<script>
import { mapActions } from "vuex";
import getTodayString from "../../utils/today-string";

export default {
  data() {
    return {
      show: false,
      task: {
        projectId: this.section.projectId,
        sectionId: this.section.id,
        title: "",
        dueDate: getTodayString(),
      },
      defaultDates: ["오늘", "내일", "모레"],
    };
  },
  methods: {
    ...mapActions(["addTask"]),
    submit() {
      this.addTask(this.task);
      this.task = {
        projectId: this.section.projectId,
        sectionId: this.section.id,
        title: "",
        dueDate: getTodayString(),
      };
      this.show = !this.show;
    },
    showForm(target) {
      if (target === "url") {
        whale.runtime.sendMessage("ekioepkamjlegkeihddddbcchkdcbihb", "hi", ({ currentUrl }) => {
          this.task.title = `[웹사이트 별명](${currentUrl})`;
        });
      }
      this.show = !this.show;
    },
    closeForm() {
      this.task.title = "";
      this.show = !this.show;
    },
  },
  props: {
    section: Object,
    buttonTitle: String,
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
