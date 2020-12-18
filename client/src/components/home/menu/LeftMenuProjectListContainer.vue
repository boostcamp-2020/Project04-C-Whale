<template>
  <v-list-group small :value="false" sub-group active-class="list-active px-3">
    <template v-slot:activator>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title class="font-14">프로젝트</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </template>
    <v-list-item-group active-class="list-active">
      <ProjectList
        @openUpdateDialog="openUpdateDialog"
        @openDeleteDialog="openDeleteDialog"
        @setFavorite="setFavorite"
        :projectInfos="projectInfos"
      />

      <v-list-item
        @click="openAddDialog"
        inactive
        class="add-btn pl-4"
        exact-active-class="list-active"
      >
        <v-list-item-icon class="mr-1">
          <v-icon small color="whaleGreen">mdi-plus</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title class="font-14 px-3">프로젝트 추가 </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>

    <ProjectFormModal :dialog="addDialog" @closeModal="addDialog = !addDialog" type="add" />

    <ProjectFormModal
      v-if="projectInfos.find((project) => project.id === projectId)"
      @closeModal="updateDialog = !updateDialog"
      :dialog="updateDialog"
      :projectInfo="projectInfos.find((project) => project.id === projectId)"
      type="update"
    />

    <ProjectDeleteModal
      v-if="projectInfos.find((project) => project.id === projectId)"
      @closeModal="deleteDialog = !deleteDialog"
      :dialog="deleteDialog"
      :projectInfo="projectInfos.find((project) => project.id === projectId)"
    />
  </v-list-group>
</template>

<script>
import ProjectList from "@/components/home/menu/LeftMenuProjectList";
import ProjectFormModal from "@/components/project/ProjectFormModal";
import ProjectDeleteModal from "@/components/project/ProjectDeleteModal";
import { mapActions } from "vuex";

export default {
  components: {
    ProjectFormModal,
    ProjectDeleteModal,
    ProjectList,
  },
  props: {
    projectInfos: Array,
  },
  data() {
    return {
      addDialog: false,
      updateDialog: false,
      deleteDialog: false,
      projectId: "",
    };
  },
  methods: {
    ...mapActions(["updateProject"]),
    openAddDialog() {
      this.addDialog = true;
    },
    openUpdateDialog(projectId) {
      this.projectId = projectId;
      this.updateDialog = true;
    },
    openDeleteDialog(projectId) {
      this.projectId = projectId;
      this.deleteDialog = true;
    },
    setFavorite(projectId) {
      this.updateProject({ projectId, data: { isFavorite: true } });
    },
  },
};
</script>

<style lang="scss">
.list-active {
  color: black !important;
}
.add-btn {
  cursor: pointer;
}
.task-count {
  color: grey;
}
.v-list-group__header {
  padding-left: 12px !important;
}
.v-list-group--sub-group .v-list-item__icon:first-child {
  margin-right: 4px !important;
}
.white-space-normal {
  white-space: normal;
}
</style>
