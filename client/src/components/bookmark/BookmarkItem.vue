<template>
  <!-- TODO: :to 수정, UI 만들기 -->
  <v-list-item :to="bookmark.url">
    <v-list-item-content>
      <v-list-item-title v-text="bookmark.title"></v-list-item-title>
    </v-list-item-content>
  </v-list-item>
</template>

<script>
export default {
  props: {
    bookmark: Object,
  },
};
</script>

<style lang="scss"></style>
