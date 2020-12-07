<template>
  <div>
    <v-list-item v-for="comment in this.comments" :key="comment.id">
      <CommentItem :comment="comment" />
    </v-list-item>
    <CommentFormContainer />
    <div>{{ this.comments }}</div>
  </div>
</template>
<script>
import CommentItem from "@/components/task/CommentItem";
import CommentFormContainer from "@/components/task/CommentFormContainer";

export default {
  props: {
    comments: Array,
  },

  components: { CommentItem, CommentFormContainer },
};
</script>
<style></style>
