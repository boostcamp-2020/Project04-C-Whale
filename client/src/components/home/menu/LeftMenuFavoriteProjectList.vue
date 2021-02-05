<template>
  <div>
    <v-list-item-group active-class="font-weight-bold">
      <v-list-item class="pl-4" :to="`/project/${managedProject.id}`">
        <v-list-item-icon class="mr-1"
          ><v-icon small color="blue">mdi-inbox</v-icon></v-list-item-icon
        >
        <v-list-item-content class="px-3" :key="managedProject.id">
          <v-list-item-title class="font-14">
            {{ managedProject.title }} <span>{{ managedProject.taskCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-list-item class="pl-4" :to="`/today`">
        <v-list-item-icon class="mr-1">
          <v-icon small color="red">mdi-calendar-today</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-3">
          <v-list-item-title class="font-14">
            오늘 <span>{{ taskCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <LeftMenuProjectList
        @openUpdateDialog="openUpdateDialog"
        @openDeleteDialog="openDeleteDialog"
        @setFavorite="setFavorite"
        :projectInfos="favoriteProjectInfos"
        type="favorite"
      />

      <ProjectFormModal
        v-if="favoriteProjectInfos.find((project) => project.id === projectId)"
        @closeModal="updateDialog = !updateDialog"
        :dialog="updateDialog"
        :projectInfo="favoriteProjectInfos.find((project) => project.id === projectId)"
        type="update"
      />

      <ProjectDeleteModal
        v-if="favoriteProjectInfos.find((project) => project.id === projectId)"
        @closeModal="deleteDialog = !deleteDialog"
        :dialog="deleteDialog"
        :projectInfo="favoriteProjectInfos.find((project) => project.id === projectId)"
      />
    </v-list-item-group>
  </div>
</template>

<script>
import LeftMenuProjectList from "@/components/home/menu/LeftMenuProjectList";
import ProjectFormModal from "@/components/project/ProjectFormModal";
import ProjectDeleteModal from "@/components/project/ProjectDeleteModal";
import { mapActions } from "vuex";

export default {
  components: {
    ProjectFormModal,
    ProjectDeleteModal,
    LeftMenuProjectList,
  },
  props: {
    managedProject: Object,
    taskCount: Number,
    favoriteProjectInfos: Array,
  },
  data() {
    return { updateDialog: false, deleteDialog: false, projectId: "" };
  },
  methods: {
    ...mapActions(["updateProject"]),
    openUpdateDialog(projectId) {
      this.projectId = projectId;
      this.updateDialog = true;
    },
    openDeleteDialog(projectId) {
      this.projectId = projectId;
      this.deleteDialog = true;
    },
    setFavorite(projectId) {
      this.updateProject({ projectId, data: { isFavorite: false } });
    },
  },
};
</script>

<style lang="scss">
.font-14 {
  font-size: 14px;
}
</style>
