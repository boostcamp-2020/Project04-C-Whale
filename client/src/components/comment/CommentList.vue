<template>
  <div>
    <v-list-item v-for="comment in comments" :key="comment.id">
      <CommentItem :comment="comment" />
    </v-list-item>
    <CommentFormContainer />
  </div>
</template>
<script>
import CommentItem from "@/components/comment/CommentItem";
import CommentFormContainer from "@/components/comment/CommentFormContainer";

export default {
  props: {
    comments: Array,
  },

  components: { CommentItem, CommentFormContainer },
};
</script>
<style></style>
