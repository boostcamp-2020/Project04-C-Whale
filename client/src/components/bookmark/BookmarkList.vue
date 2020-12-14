<template>
  <v-flex>
    <div v-if="bookmarks">
      <BookmarkItem v-for="bookmark in bookmarks" :bookmark="bookmark" :key="bookmark.id" />
    </div>
    <BookmarkFormContainer />
  </v-flex>
</template>

<script>
import BookmarkFormContainer from "./BookmarkFormContainer";
import BookmarkItem from "./BookmarkItem";
export default {
  components: {
    BookmarkFormContainer,
    BookmarkItem,
  },
  props: {
    bookmarks: Array,
  },
};
</script>

<style lang="scss"></style>
