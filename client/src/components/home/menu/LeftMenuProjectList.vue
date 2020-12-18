<template>
  <div>
    <v-list-item
      v-for="project in projectInfos"
      :key="project.id"
      :to="`/project/${project.id}`"
      class="pl-4 max-224"
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
            <v-btn icon v-on="on" @click.prevent.stop>
              <v-icon>mdi-dots-horizontal</v-icon>
            </v-btn>
          </v-list-item-action>
        </template>
        <v-list>
          <v-list-item @click="$emit('openUpdateDialog', project.id)">
            <v-list-item-title class="font-14">프로젝트 수정 </v-list-item-title>
          </v-list-item>
          <v-list-item @click="$emit('openDeleteDialog', project.id)">
            <v-list-item-title class="font-14">프로젝트 삭제 </v-list-item-title>
          </v-list-item>
          <v-list-item @click="$emit('setFavorite', project.id)">
            <v-list-item-title class="font-14">즐겨찾기 {{ setFavoriteType }} </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-list-item>
  </div>
</template>

<script>
export default {
  props: {
    projectInfos: Array,
    type: String,
  },
  data() {
    return {
      setFavoriteType: this.type === "favorite" ? "삭제" : "추가",
    };
  },
};
</script>

<style scoped>
.max-224 {
  max-width: 224px !important;
}
</style>
