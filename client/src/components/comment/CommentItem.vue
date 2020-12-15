<template>
  <div class="comment_item-container" @mouseover="showEditUtils" @mouseleave="unshowEditUtils">
    <div class="py-3" v-if="isVisibleCommentEdit">
      <form @submit.prevent="update">
        <div class="commment-form-data px-4 py-2">
          <v-text-field v-model="newContent" ref="input"></v-text-field>
          <v-btn type="submit" depressed color="primary" :disabled="newContent.length <= 0"
            >업데이트</v-btn
          >
          <v-btn class="white--text" @click="unshowCommentEdit" depressed color="#07C4A3"
            >취소</v-btn
          >
        </div>
      </form>
    </div>

    <v-list-item v-else class="flex-grow-1 justify-space-around">
      <v-list-item-content>
        <v-list-item-title class="font-14">
          {{ comment.content }} <span class="d-inline-block ml-2">{{ timeDateString }}</span>
        </v-list-item-title>
      </v-list-item-content>
      <div v-if="isVisibleEditUtils">
        <v-btn class="ma-2" outlined x-small color="whaleGreen" @click="showCommentEdit">
          <v-icon>mdi-pencil</v-icon>
          수정
        </v-btn>
        <v-btn class="ma-2" outlined x-small color="whaleGreen" @click="remove(comment.id)">
          <v-icon>mdi-delete</v-icon>
          삭제
        </v-btn>
      </div>
    </v-list-item>
  </div>
</template>
<script>
import { mapActions } from "vuex";
export default {
  props: {
    comment: Object,
  },
  data() {
    return {
      isVisibleCommentEdit: false,
      isVisibleEditUtils: false,
      newContent: this.comment.content,
    };
  },
  computed: {
    timeDateString() {
      return new Date(this.comment.updatedAt).toLocaleString();
    },
  },
  methods: {
    ...mapActions(["updateComment", "deleteComment"]),
    showEditUtils() {
      if (!this.isVisibleCommentEdit) {
        this.isVisibleEditUtils = true;
      }
    },
    unshowEditUtils() {
      this.isVisibleEditUtils = false;
    },
    showCommentEdit() {
      this.unshowEditUtils();
      this.isVisibleCommentEdit = true;
    },
    unshowCommentEdit() {
      this.newContent = this.comment.content;
      this.isVisibleCommentEdit = false;
    },
    update() {
      const updateData = { ...this.comment, content: this.newContent };
      this.updateComment(updateData);
      this.unshowCommentEdit();
    },
    remove(commentId) {
      const isRemove = confirm("정말 삭제하시겠습니까?");
      if (isRemove) {
        const data = { id: commentId, taskId: this.$route.params.taskId };
        this.deleteComment(data);
        alert("삭제되었습니다.");
      }
    },
  },
};
</script>
<style>
.comment_item-container {
  width: 100%;
}
</style>
