<template>
  <v-flex>
    <BookmarkFormContainer />
    <div v-for="bookmark in bookmarks" :key="bookmark.id">
      <BookmarkItem :bookmark="bookmark" />
    </div>
  </v-flex>
</template>

<script>
import BookmarkFormContainer from "./BookmarkFormContainer";
import BookmarkItem from "./BookmarkItem";
export default {
  data() {
    return {
      bookmarks: [
        { id: 0, title: "타이틀", url: "https://naver.com" },
        { id: 1, title: "타티을 2", url: "https://google.com" },
      ],
    };
  },
  components: {
    BookmarkFormContainer,
    BookmarkItem,
  },
};
</script>

<style lang="scss"></style>
