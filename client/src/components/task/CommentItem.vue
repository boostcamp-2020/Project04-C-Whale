<template>
  <div
    class="comment_item-container d-flex flex-row"
    @mouseover="showEditComment"
    @mouseleave="unshowEditComment"
  >
    <v-list-item-group class="flex-grow-1">
      <v-list-item-title> {{ comment.updatedAt }} </v-list-item-title>
      <v-list-item-content> {{ comment.content }} </v-list-item-content>
    </v-list-item-group>
    <!-- <div v-if="showEdit">asd</div> -->
    <div v-if="showEdit">
      <v-btn class="ma-2" outlined x-small color="indigo" @click="updateComment">
        <v-icon>mdi-pencil</v-icon>
        수정
      </v-btn>
      <v-btn class="ma-2" outlined x-small color="indigo" @click="deleteComment">
        <v-icon>mdi-delete</v-icon>
        삭제
      </v-btn>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    comment: Object,
  },
  data() {
    return {
      showEdit: false,
    };
  },
  methods: {
    showEditComment() {
      this.showEdit = true;
    },
    unshowEditComment() {
      this.showEdit = false;
    },
    updateComment() {
      alert("수정 선택");
    },
    deleteComment() {
      alert("삭제 선택");
    },
  },
};
</script>
<style>
.comment_item-container {
  width: 100%;
}
</style>
