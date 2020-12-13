<template>
  <v-list-group :value="false" sub-group active-class="list-active">
    <template v-slot:activator>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title class="font-14">북마크</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </template>
    <v-list-item-group active-class="list-active">
      <v-list-group
        v-for="task in tasks"
        :key="task.id"
        active-class="font-weight-bold list-active"
        class="pl-2"
        :value="false"
        sub-group
      >
        <template v-slot:activator>
          <v-list-item class="pl-4">
            <v-list-item-content>
              <v-list-item-title class="font-14">{{ task.title }}</v-list-item-title>
            </v-list-item-content>
            <v-menu :offset-y="true">
              <template v-slot:activator="{ on }">
                <v-list-item-action class="my-0">
                  <v-btn icon v-on="on" @click.prevent.stop>
                    <v-icon>mdi-dots-horizontal</v-icon>
                  </v-btn>
                </v-list-item-action>
              </template>
              <v-list>
                <v-list-item @click.stop="uploadBookmarks(task)">
                  <v-list-item-title class="font-14">브라우저 북마크로 등록</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </v-list-item>
        </template>
        <v-list-item-group active-class="list-active">
          <v-list-item
            v-for="bookmark in task.bookmarks"
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
    </v-list-item-group>
  </v-list-group>
</template>

<script>
import whaleApi from "@/utils/whaleApi";
import { mapMutations } from "vuex";

export default {
  props: {},
  components: {},
  data() {
    return {
      tasks: [
        {
          id: 0,
          title: "task 1 ",
          bookmarks: [
            {
              id: 0,
              title: "bookmakr 1",
              url:
                "https://developer.chrome.com/docs/extensions/reference/bookmarks/#type-CreateDetails",
            },
            {
              id: 1,
              title: "bookmark2",
              url:
                "https://github.com/GoogleChrome/chrome-extensions-samples/blob/master/api/bookmarks/basic/popup.js",
            },
          ],
        },
        {
          id: 1,
          title: "task 2",
          bookmarks: [
            {
              id: 0,
              title: "bookmakr 1",
              url:
                "https://developer.chrome.com/docs/extensions/reference/bookmarks/#type-CreateDetails",
            },
            {
              id: 1,
              title: "bookmark2",
              url:
                "https://github.com/GoogleChrome/chrome-extensions-samples/blob/master/api/bookmarks/basic/popup.js",
            },
          ],
        },
      ],
    };
  },
  methods: {
    ...mapMutations(["SET_SUCCESS_ALERT", "SET_ERROR_ALERT"]),
    uploadBookmarks(task) {
      try {
        whaleApi.createBookmark({ folderTitle: task.title, bookmarks: task.bookmarks });
        this.SET_SUCCESS_ALERT("북마크가 등록되었습니다");
      } catch (err) {
        this.SET_ERROR_ALERT(err);
      }
    },
  },
};
</script>

<style lang="scss"></style>
