<template>
  <v-list-item>
    <v-layout row wrap>
      <div v-if="show" class="task-form-container">
        <form @submit.prevent="onSubmit">
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
            <v-btn @click="show = !show" text color="primary">취소</v-btn>
          </v-flex>
        </form>
      </div>
      <div v-if="!show">
        <v-btn @click="show = !show" text color="primary">+ 작업 추가</v-btn>
      </div>
    </v-layout>
  </v-list-item>
</template>

<script>
import { mapActions } from "vuex";
import { getTodayString } from "../../utils/date";

export default {
  data() {
    return {
      show: false,
      task: {
        projectId: this.projectId,
        sectionId: this.sectionId,
        title: "",
        dueDate: getTodayString(),
      },
      defaultDates: ["오늘", "내일", "모레"],
      // date: getTodayString(),
      // displayDate: "오늘",
    };
  },
  methods: {
    ...mapActions(["addTask"]),
    onSubmit() {
      this.addTask(this.task);
      this.task = {
        projectId: this.projectId,
        sectionId: this.sectionId,
        title: "",
        dueDate: getTodayString(),
      };
      this.show = !this.show;
    },
  },
  props: ["projectId", "sectionId"],
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
input[type="text"] {
  margin-bottom: 10px;
}
input:focus {
  outline: none;
}
</style>
