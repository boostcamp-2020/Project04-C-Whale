<template>
  <div class="py-3">
    <form @submit.prevent="submit">
      <div class="commment-form-data px-4 py-2">
        <v-text-field
          hide-details
          v-model="comment.content"
          placeholder="댓글 작성"
          class="mb-2 mt-0 pt-0"
        ></v-text-field>
        <v-btn type="submit" depressed color="whaleGreen" :disabled="comment.content.length <= 0"
          >댓글 추가</v-btn
        >
      </div>
    </form>
  </div>
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
  border: 1px solid #ddd;
  min-width: 440px;
  border-radius: 5px;
}
</style>
