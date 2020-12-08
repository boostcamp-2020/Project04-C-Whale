<template>
  <div>
    <v-list-item-group active-class="font-weight-bold">
      <v-list-item class="pl-4" :to="`/project/${managedProject.id}`">
        <v-list-item-icon class="mr-1"
          ><v-icon small color="blue">mdi-inbox</v-icon></v-list-item-icon
        >
        <v-list-item-content class="px-3" :key="managedProject.id">
          <v-list-item-title class="font-14">
            관리함 <span>{{ managedProject.taskCount }}</span>
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
      <v-list-item
        v-for="favoriteProjectInfo in favoriteProjectInfos"
        class="pl-4"
        :key="favoriteProjectInfo.id"
        @click="pushRoute(favoriteProjectInfo.id)"
      >
        <v-list-item-icon class="mr-1">
          <v-icon small :color="favoriteProjectInfo.color">mdi-circle</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-3">
          <v-list-item-title class="font-14">
            {{ favoriteProjectInfo.title }} <span>{{ favoriteProjectInfo.taskCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
        <v-menu :offset-y="true">
          <template v-slot:activator="{ on }">
            <v-list-item-action>
              <v-btn icon v-on.prevent="on">
                <v-icon>mdi-dots-horizontal</v-icon>
              </v-btn>
            </v-list-item-action>
          </template>
          <v-list>
            <v-list-item @click.stop="openUpdateDialog(favoriteProjectInfo.id)">
              <v-list-item-title class="font-14">프로젝트 수정 </v-list-item-title>
            </v-list-item>
            <v-list-item @click.stop="openDeleteDialog(favoriteProjectInfo.id)">
              <v-list-item-title class="font-14">프로젝트 삭제 </v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-list-item>
      <UpdateProjectModal
        v-if="favoriteProjectInfos.find((project) => project.id === projectId)"
        :dialog="updateDialog"
        v-on:handleUpdateModal="updateDialog = !updateDialog"
        :projectInfo="favoriteProjectInfos.find((project) => project.id === projectId)"
      />
      <DeleteProjectModal
        v-if="favoriteProjectInfos.find((project) => project.id === projectId)"
        :dialog="deleteDialog"
        v-on:handleDeleteModal="deleteDialog = !deleteDialog"
        :projectInfo="favoriteProjectInfos.find((project) => project.id === projectId)"
      />
    </v-list-item-group>
  </div>
</template>

<script>
import UpdateProjectModal from "@/components/project/UpdateProjectModal.vue";
import DeleteProjectModal from "@/components/project/DeleteProjectModal.vue";

export default {
  props: {
    managedProject: Object,
    taskCount: Number,
    favoriteProjectInfos: Array,
  },
  components: {
    UpdateProjectModal,
    DeleteProjectModal,
  },
  data() {
    return { updateDialog: false, deleteDialog: false, projectId: "" };
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
.font-14 {
  font-size: 14px;
}
</style>
