<template>
  <div class="project-container">
    <ProjectContainerHeader
      @selectListView="changeToListView"
      @selectBoardView="changeToBoardView"
      :project="project"
    />

    <div :class="{ 'board-view': boardView }">
      <SectionContainer
        v-for="section in project.sections"
        :key="section.id"
        :section="section"
        class="mb-3"
      />
    </div>
  </div>
</template>

<script>
import { mapActions } from "vuex";
import ProjectContainerHeader from "./ProjectContainerHeader";
import SectionContainer from "@/components/project/SectionContainer";

export default {
  props: {
    project: Object,
  },
  data() {
    return {
      boardView: false,
    };
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
    changeToListView() {
      this.boardView = false;
    },
    changeToBoardView() {
      this.boardView = true;
    },
  },
  components: {
    SectionContainer,
    ProjectContainerHeader,
  },
};
</script>

<style>
.project-container {
  width: 100%;
  /* max-width: 600px; */
}

.v-dialog {
  max-width: 80%;
  min-height: 80%;
  background-color: white;
}

.board-view {
  display: flex;
}
</style>
