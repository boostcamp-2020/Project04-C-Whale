<template>
  <v-tabs v-model="active" color="#1C2B82" slider-color="#07C4A3">
    <v-tab class="flex-grow-1" v-for="tabTitle in tabTitles" :key="tabTitle" ripple>
      {{ tabTitle }}
    </v-tab>
    <!-- <v-tab-item v-for="tabTitle in this.tabTitles" :key="tabTitle"> -->
    <v-tab-item v-for="(value, name) in tabTitles" :key="name">
      <div v-if="name === tabNames.childTask">
        <!-- <v-card flat v-for="childTask in tasks" :key="childTask.id"> -->
        <task-item v-for="childTask in tasks" :key="childTask.id" :task="childTask" />
        <AddTask :projectId="projectId" :parentId="parentId" :sectionId="sectionId" />
      </div>
      <div v-else-if="name === tabNames.comment">
        <div>하이 코멘트</div>
      </div>
      <div v-else-if="name === tabNames.bookmark">
        <div>하이 북마크</div>
      </div>
      <div v-else>잘못된 Tab Name 입니다.</div>
    </v-tab-item>
  </v-tabs>
</template>

<script>
import TaskItem from "@/components/project/TaskItem";
import AddTask from "@/components/project/AddTask";

export default {
  props: {
    tasks: Array,
    tabTitles: Object,
    projectId: String,
    sectionId: String,
  },
  data() {
    return {
      active: null,
      parentId: this.$route.params.taskId,
      tabNames: {
        childTask: "childTaskTab",
        comment: "taskCommentTab",
        bookmark: "taskBookmarkTab",
      },
    };
  },
  methods: {
    next() {
      const active = parseInt(this.active);
      this.active = active < 2 ? active + 1 : 0;
    },
  },
  components: { TaskItem, AddTask },
};
</script>

<style></style>
