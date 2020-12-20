<template>
  <v-tabs v-model="active" color="#1C2B82" slider-color="#07C4A3">
    <v-tab class="flex-grow-1" v-for="tab in tabList" :key="tab.title" ripple>
      {{ tab.title }} {{ tab.count }}
    </v-tab>
    <!-- 하위 작업-->
    <v-tab-item>
      <div v-if="isParent">
        <ChildTaskList
          :parentTask="parentTask"
          :projectId="projectId"
          :sectionId="sectionId"
          :parentId="parentId"
        />
        <AddTask :projectId="projectId" :sectionId="sectionId" :parentId="parentId" />
      </div>
      <div v-else class="py-3">
        <p class="text-center">하위작업을 더이상 생성할 수 없습니다</p>
        <v-img src="@/assets/halgoraedo.png"></v-img>
      </div>
    </v-tab-item>
    <!-- 댓글-->
    <v-tab-item>
      <CommentList :comments="comments" />
    </v-tab-item>
    <!-- 북마크-->
    <v-tab-item>
      <BookmarkList :bookmarks="bookmarks" />
    </v-tab-item>
  </v-tabs>
</template>

<script>
import ChildTaskList from "@/components/task/ChildTaskList";
import CommentList from "@/components/comment/CommentList";
import BookmarkList from "@/components/bookmark/BookmarkList";
import AddTask from "./AddTask.vue";

export default {
  props: {
    tasks: Array,
    comments: Array,
    bookmarks: Array,
    projectId: String,
    sectionId: String,
    isParent: Boolean,
    parentTask: Object,
  },
  data() {
    return {
      tabList: {
        childTask: { title: "하위 작업", count: 0 },
        comment: { title: "댓글", count: 0 },
        bookmark: { title: "북마크", count: 0 },
      },
      active: null,
      parentId: this.$route.params.taskId,
    };
  },
  methods: {
    next() {
      const active = parseInt(this.active);
      this.active = active % 3;
    },
  },
  beforeUpdate() {
    this.tabList.childTask.count = this.task ? this.tasks.length : 0;
    this.tabList.comment.count = this.comments ? this.comments.length : 0;
    this.tabList.bookmark.count = this.bookmarks ? this.bookmarks.length : 0;
  },
  components: { ChildTaskList, CommentList, BookmarkList, AddTask },
};
</script>

<style>
.v-tab {
  max-width: 100% !important;
}
</style>
