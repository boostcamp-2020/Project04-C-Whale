<template>
  <v-list-item :href="bookmark.url">
    <v-list-item-icon>
      <v-icon color="primary">mdi-book</v-icon>
    </v-list-item-icon>
    <v-list-item-content>
      <v-list-item-title v-text="bookmark.title + '(바로가기)'"></v-list-item-title>
    </v-list-item-content>
    <v-spacer></v-spacer>
    <v-spacer></v-spacer>
    <v-btn @click.prevent="DeleteBookmark" color="primary">삭제</v-btn>
  </v-list-item>
</template>

<script>
import { mapActions } from "vuex";
export default {
  props: {
    bookmark: Object,
  },
  methods: {
    ...mapActions(["deleteBookmark"]),
    DeleteBookmark() {
      this.deleteBookmark({ taskId: this.$route.params.taskId, bookmarkId: this.bookmark.id });
    },
  },
};
</script>

<style lang="scss"></style>
