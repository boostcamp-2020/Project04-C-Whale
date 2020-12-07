<template>
  <div>
    <v-list-item v-for="comment in this.comments" :key="comment.id">
      <CommentItem :comment="comment" />
    </v-list-item>
    <form @submit.prevent="submit">
      <div class="comment-form-data">
        <v-text-field v-model="newComment.content" placeholder="댓글 작성"></v-text-field>
        <v-btn type="submit" depressed color="primary" :disabled="newComment.content.length <= 0"
          >댓글 추가</v-btn
        >
      </div>
      <v-flex> </v-flex>
    </form>
    <div>{{ this.comments }}</div>
  </div>
</template>
<script>
import { mapActions } from "vuex";
import CommentItem from "@/components/task/CommentItem";
export default {
  props: {
    comments: Array,
  },
  data() {
    return {
      newComment: {
        taskId: this.$route.params.taskId,
        content: "",
      },
    };
  },
  methods: {
    ...mapActions(["addComment"]),
    submit() {
      this.addComment(this.newComment);
      this.newComment = {
        taskId: this.$route.params.taskId,
        content: "",
      };
    },
  },
  components: { CommentItem },
};
</script>
<style>
.comment-form-data {
  min-height: 10%;
  border-style: groove;
  border-radius: 5px;
}
</style>
