<template>
  <div v-click-outside="clickOutside">
    <div v-if="showForm">
      <form @submit.prevent="submit">
        <div class="title-data">
          <input type="text" v-model="newTitle" ref="input" />
          <div>
            <v-btn type="submit" depressed color="primary">변경</v-btn>
            <v-btn @click="toggle" text color="primary">취소</v-btn>
          </div>
        </div>
      </form>
    </div>
    <div v-else @click="toggle">
      <p class="mb-0">{{ originalTitle }}</p>
    </div>
  </div>
</template>

<script>
import { mapActions } from "vuex";

export default {
  props: ["originalTitle", "type", "parent"],
  data() {
    return {
      showForm: false,
      newTitle: this.originalTitle,
    };
  },
  methods: {
    ...mapActions(["updateProjectTitle", "updateSectionTitle"]),
    toggle() {
      this.showForm = !this.showForm;

      if (this.showForm) {
        this.$nextTick(() => {
          this.$refs.input.focus();
        });
      }
    },
    clickOutside() {
      if (this.showForm) {
        this.toggle();
      }
    },
    submit() {
      switch (this.type) {
        case "project":
          this.updateProjectTitle({
            projectId: this.parent.id,
            title: this.newTitle,
          });
          break;
        case "section":
          this.updateSectionTitle({
            projectId: this.parent.projectId,
            sectionId: this.parent.id,
            title: this.newTitle,
          });
          break;
        case "task":
          break;
      }
      this.toggle();
    },
  },
  watch: {
    originalTitle: function () {
      this.newTitle = this.originalTitle;
      this.showForm = false;
    },
  },
};
</script>

<style>
.title-data {
  display: flex;
  flex-direction: column;
  border-radius: 5px;
}
input[type="text"] {
  margin-bottom: 10px;
}
input:focus {
  outline: none;
}
</style>
