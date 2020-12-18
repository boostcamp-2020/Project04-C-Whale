<template>
  <div>
    <div v-if="commentsSorted.length > 0">
      <CommentItem v-for="comment in commentsSorted" :key="comment.id" :comment="comment" />
    </div>
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
      return this.comments
        ? [...this.comments].sort(
            (commentA, commentB) => new Date(commentA.createdAt) - new Date(commentB.createdAt)
          )
        : [];
    },
  },
};
</script>
<style></style>
