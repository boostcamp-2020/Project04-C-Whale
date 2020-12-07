<template>
  <div>
    <div>하이 코멘트</div>
    <v-list-item v-for="comment in this.comments" :key="comment.id">
      <v-list-item-group>
        <v-list-item-title> {{ comment.updatedAt }} </v-list-item-title>
        <v-list-item-content> {{ comment.content }} </v-list-item-content>
      </v-list-item-group>
    </v-list-item>
    <div>{{ this.comments }}</div>
    <form @submit.prevent="submit">
      <div class="comment-form-data">
        <input type="text" v-model="newComment.content" placeholder="댓글 작성" />
      </div>
      <v-flex>
        <v-btn type="submit" depressed color="primary" :disabled="newComment.content.length <= 0"
          >댓글 추가</v-btn
        >
      </v-flex>
    </form>
  </div>
</template>
<script>
import { mapActions } from "vuex";
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
      try {
        this.addComment(this.newComment);
        this.newComment = {
          taskId: this.$route.params.taskId,
          content: "",
        };
      } catch (err) {
        console.log("오는건가");
      }
    },
  },
};
</script>
<style></style>
