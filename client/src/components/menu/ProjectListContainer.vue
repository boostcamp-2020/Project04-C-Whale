<template>
  <v-list-group small :value="false" sub-group active-class="list-active px-3">
    <template v-slot:activator>
      <v-hover v-slot="{ hover }">
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="font-14">프로젝트</v-list-item-title>
          </v-list-item-content>
          <v-list-item-icon :class="{ 'd-none ': !hover }" @click.stop="addDialog = true">
            <v-icon>mdi-plus</v-icon>
          </v-list-item-icon>
        </v-list-item>
      </v-hover>
    </template>
    <v-list-item-group active-class="list-active">
      <v-list-item
        v-for="project in projectInfos"
        :key="project.id"
        @click="pushRoute(project.id)"
        class="pl-4"
        active-class="font-weight-bold list-active"
      >
        <v-list-item-icon class="mr-1">
          <v-icon small :color="project.color">mdi-circle</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-3">
          <v-list-item-title class="font-14 white-space-normal">
            {{ project.title
            }}<span class="d-inline-block ml-1 task-count">{{ project.taskCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
        <v-menu :offset-y="true">
          <template v-slot:activator="{ on }">
            <v-list-item-action class="my-0">
              <v-btn icon v-on.prevent="on">
                <v-icon>mdi-dots-horizontal</v-icon>
              </v-btn>
            </v-list-item-action>
          </template>
          <v-list>
            <v-list-item @click.stop="openUpdateDialog(project.id)">
              <v-list-item-title class="font-14">프로젝트 수정 </v-list-item-title>
            </v-list-item>
            <v-list-item @click.stop="openDeleteDialog(project.id)">
              <v-list-item-title class="font-14">프로젝트 삭제 </v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-list-item>
      <v-list-item
        @click.stop="addDialog = true"
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

    <AddProjectModal :dialog="addDialog" v-on:handleAddModal="addDialog = !addDialog" />
    <UpdateProjectModal
      v-if="projectInfos.find((project) => project.id === projectId)"
      :dialog="updateDialog"
      v-on:handleUpdateModal="updateDialog = !updateDialog"
      :projectInfo="projectInfos.find((project) => project.id === projectId)"
    />
    <DeleteProjectModal
      v-if="projectInfos.find((project) => project.id === projectId)"
      :dialog="deleteDialog"
      v-on:handleDeleteModal="deleteDialog = !deleteDialog"
      :projectInfo="projectInfos.find((project) => project.id === projectId)"
    />
  </v-list-group>
</template>

<script>
import AddProjectModal from "@/components/project/AddProjectModal.vue";
import UpdateProjectModal from "@/components/project/UpdateProjectModal.vue";
import DeleteProjectModal from "@/components/project/DeleteProjectModal.vue";

export default {
  props: {
    projectInfos: Array,
  },
  components: {
    AddProjectModal,
    UpdateProjectModal,
    DeleteProjectModal,
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
    pushRoute(projectId) {
      this.$router.push("/project/" + projectId);
    },
    openUpdateDialog(projectId) {
      this.projectId = projectId;
      this.updateDialog = true;
    },
    openDeleteDialog(projectId) {
      this.projectId = projectId;
      this.deleteDialog = true;
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
