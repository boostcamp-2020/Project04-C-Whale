<template>
  <div class="project-container">
    <ProjectContainerHeader
      @selectListView="changeToListView"
      @selectBoardView="changeToBoardView"
      @showAddSection="toggleAddSection"
      @toggleShowDoneTask="toggleShowDoneTask"
      :project="project"
      :showDoneTask="showDoneTask"
    />

    <div :class="{ 'board-view': boardView }" class="section-container">
      <SectionContainer
        v-for="section in project.sections"
        :key="section.id"
        :id="section.id"
        :projectId="project.id"
        :section="section"
        :showDoneTask="showDoneTask"
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
import { mapActions } from "vuex";
import ProjectContainerHeader from "@/components/project/ProjectContainerHeader";
import SectionContainer from "@/components/project/section/SectionContainer";
import AddSection from "@/components/project/section/AddSection";
import bus from "@/utils/bus";

export default {
  components: {
    SectionContainer,
    ProjectContainerHeader,
    AddSection,
  },
  props: {
    project: Object,
    sections: Array,
  },
  data() {
    return {
      boardView: !this.project.isList,
      showAddSection: false,
      showDoneTask: false,
    };
  },
  created() {
    bus.$on("moveToTaskDetail", (destinationInfo) => {
      this.$router.push(destinationInfo).catch(() => {});
    });
  },
  beforeDestroy() {
    bus.$off("moveToTaskDetail");
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
    toggleShowDoneTask() {
      this.showDoneTask = !this.showDoneTask;
    },
  },
};
</script>

<style lang="scss" scoped>
.project-container {
  height: 100%;
  display: flex;
  flex-direction: column;
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
}
</style>
