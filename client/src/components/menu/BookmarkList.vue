<template>
  <v-list-group small :value="false" sub-group active-class="list-active px-3">
    <template v-slot:activator>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title class="font-14">북마크</v-list-item-title>
        </v-list-item-content>
        <!-- TODO: 이벤트 버블링 오류 고치기
          <v-list-item-icon :class="{ 'd-none ': !hover }" @click.stop.prevent="addDialog = true">
            <v-icon>mdi-plus</v-icon>
          </v-list-item-icon> -->
      </v-list-item>
    </template>
    <v-list-item-group active-class="list-active">
      <v-list-item
        v-for="bookmark in bookmarks"
        :key="bookmark.id"
        class="pl-4"
        active-class="font-weight-bold list-active"
      >
        <v-list-item-icon class="mr-1">
          <v-icon small color="whaleGreen">mdi-book</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-3">
          <v-list-item-title class="font-14 white-space-normal">
            {{ bookmark.title }}
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>
  </v-list-group>
</template>

<script>
export default {
  props: {},
  components: {},
  data() {
    return {
      bookmarks: [
        { id: 0, title: "북마크 1" },
        { id: 1, title: "북마크2" },
      ],
    };
  },
  methods: {},
};
</script>

<style lang="scss"></style>
