<template>
  <div class="project-container">
    <ProjectContainerHeader
      @selectListView="changeToListView"
      @selectBoardView="changeToBoardView"
      @showAddSection="toggleAddSection"
      :project="project"
    />

    <div :class="{ 'board-view': boardView }" class="section-container">
      <SectionContainer
        v-for="section in project.sections"
        :key="section.id"
        :project="project"
        :section="section"
        class="mb-3 section-container"
      />
    </div>

    <AddSection
      @closeAddSection="toggleAddSection"
      :show="showAddSection"
      :projectId="project.id"
    />
  </div>
</template>

<script>
import { mapActions } from "vuex";
import ProjectContainerHeader from "./ProjectContainerHeader";
import SectionContainer from "@/components/project/SectionContainer";
import AddSection from "@/components/project/AddSection";

export default {
  props: {
    project: Object,
  },
  data() {
    return {
      boardView: false,
      showAddSection: false,
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
    toggleAddSection() {
      this.showAddSection = !this.showAddSection;
    },
  },
  components: {
    SectionContainer,
    ProjectContainerHeader,
    AddSection,
  },
};
</script>

<style>
.project-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  /* align-items: flex-start; */
  max-width: 700px;
  overflow-x: scroll;
}

.v-dialog {
  max-width: 80%;
  min-height: 80%;
  background-color: white;
}

.board-view {
  display: flex;

  /* flex-wrap: nowrap;
  overflow-x: auto; */
}
.section-container {
  max-width: 700px;
}
</style>
