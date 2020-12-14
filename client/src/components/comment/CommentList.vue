<template>
  <div>
    <v-list-item v-for="comment in commentsSorted" :key="comment.id">
      <CommentItem :comment="comment" />
    </v-list-item>
    <CommentFormContainer />
  </div>
</template>
<script>
import CommentItem from "@/components/comment/CommentItem";
import CommentFormContainer from "@/components/comment/CommentFormContainer";

export default {
  components: { CommentItem, CommentFormContainer },

  props: {
    comments: Array,
  },
  computed: {
    commentsSorted() {
      return [...this.comments].sort(
        (commentA, commentB) => new Date(commentA.createdAt) - new Date(commentB.createdAt)
      );
    },
  },
};
</script>
<style></style>
