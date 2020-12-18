<template>
  <div v-if="show">
    <form @submit.prevent="submit">
      <div class="section-form-data">
        <input type="text" v-model="section.title" placeholder="섹션 제목" />
      </div>
      <v-flex>
        <v-btn type="submit" depressed color="primary">섹션 추가</v-btn>
        <v-btn @click="closeForm" text color="primary">취소</v-btn>
      </v-flex>
    </form>
  </div>
</template>

<script>
import { mapActions } from "vuex";

export default {
  props: {
    show: Boolean,
    projectId: String,
  },
  data() {
    return {
      section: {
        title: "",
      },
    };
  },
  methods: {
    ...mapActions(["addSection"]),

    submit() {
      this.addSection({
        projectId: this.projectId,
        section: this.section,
      });
      this.section = {
        title: "",
      };
      this.closeForm();
    },

    closeForm() {
      this.$emit("closeAddSection");
    },
  },
};
</script>

<style scoped>
.section-form-data {
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
