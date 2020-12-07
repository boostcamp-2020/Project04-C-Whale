<template>
  <form @submit.prevent="submit">
    <div class="comment-form-data">
      <v-text-field v-model="comment.content" placeholder="댓글 작성"></v-text-field>
      <v-btn type="submit" depressed color="primary" :disabled="comment.content.length <= 0"
        >댓글 추가</v-btn
      >
    </div>
  </form>
</template>
<script>
import { mapActions } from "vuex";

export default {
  data() {
    return {
      comment: {
        taskId: this.$route.params.taskId,
        content: "",
      },
    };
  },
  methods: {
    ...mapActions(["addComment"]),
    submit() {
      this.addComment(this.comment);
      this.comment = {
        taskId: this.$route.params.taskId,
        content: "",
      };
    },
  },
};
</script>
<style>
.comment-form-data {
  min-height: 10%;
  border-style: groove;
  border-radius: 5px;
}
</style>
