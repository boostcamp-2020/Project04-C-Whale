<template>
  <v-tabs v-model="active" color="#1C2B82" slider-color="#07C4A3">
    <v-tab class="flex-grow-1" v-for="tab in tabList" :key="tab.title" ripple>
      {{ tab.title }} {{ tab.count }}
    </v-tab>
    <!-- 하위 작업-->
    <v-tab-item>
      <ChildTaskList
        :tasks="tasks"
        :projectId="projectId"
        :sectionId="sectionId"
        :parentId="parentId"
      />
    </v-tab-item>
    <!-- 댓글-->
    <v-tab-item>
      <CommentList :comments="comments" />
    </v-tab-item>
    <!-- 북마크-->
    <v-tab-item>
      <div>하이 북마크</div>
    </v-tab-item>
  </v-tabs>
</template>

<script>
import ChildTaskList from "@/components/task/ChildTaskList";
import CommentList from "@/components/comment/CommentList";

export default {
  props: {
    tasks: Array,
    comments: Array,
    tabList: Object,
    projectId: String,
    sectionId: String,
  },
  data() {
    return {
      active: null,
      parentId: this.$route.params.taskId,
    };
  },
  methods: {
    next() {
      const active = parseInt(this.active);
      this.active = active < 2 ? active + 1 : 0;
    },
  },
  components: { ChildTaskList, CommentList },
};
</script>

<style>
.v-tab {
  max-width: 100% !important;
}
</style>
