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
        v-for="(section, index) in project.sections"
        :key="section.id"
        :id="section.id"
        :position="index"
        :projectId="project.id"
        :section="section"
        @sectionDragOver="sectionDragOver"
        @sectionDrop="sectionDrop"
        class="mb-3 section-container"
      />
    </div>

    <AddSection
      @closeAddSection="toggleAddSection"
      :show="showAddSection"
      :projectId="project.id"
    />

    <keep-alive>
      <router-view :key="$route.params.taskId"></router-view>
    </keep-alive>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import ProjectContainerHeader from "./ProjectContainerHeader";
import SectionContainer from "@/components/project/SectionContainer";
import AddSection from "@/components/project/AddSection";
import bus from "@/utils/bus";

export default {
  props: {
    project: Object,
    sections: Array,
  },
  data() {
    return {
      boardView: !this.project.isList,
      showAddSection: false,
    };
  },
  computed: {
    ...mapGetters(["draggingSection"]),
  },
  methods: {
    ...mapActions(["updateTaskToDone", "updateProject"]),
    changeToListView() {
      this.updateProject({ projectId: this.project.id, data: { isList: true } });
      this.boardView = false;
    },
    changeToBoardView() {
      this.updateProject({ projectId: this.project.id, data: { isList: false } });
      this.boardView = true;
    },
    toggleAddSection() {
      this.showAddSection = !this.showAddSection;
    },
    sectionDragOver({ position }) {
      this.sections = this.sections.filter((section) => section.id !== this.draggingSection.id);
      this.sections.splice(position, 0, { ...this.draggingSection, dragging: true });
    },
    sectionDrop(e) {
      this.changeSectionPosition({
        projectId: this.project.id,
        orderedSections: this.sections.map((section) => section.id),
      });
    },
  },
  components: {
    SectionContainer,
    ProjectContainerHeader,
    AddSection,
  },
  created() {
    bus.$on("moveToTaskDetail", (destinationInfo) => {
      this.$router.push(destinationInfo).catch(() => {});
    });
  },
  beforeDestroy() {
    bus.$off("moveToTaskDetail");
  },
};
</script>

<style lang="scss">
.project-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  /* align-items: flex-start; */
  overflow-x: scroll;
}

@media screen and (max-width: 512px) {
  .project-container {
    width: 90vw;
  }
}
.v-dialog {
  max-width: 80%;
  min-height: 80%;
  background-color: white;
}

.board-view {
  display: flex;

  &.section-container {
    flex: 1 1 0;
    width: 0;
  }
  /* flex-wrap: nowrap;
  overflow-x: auto; */
}
</style>
