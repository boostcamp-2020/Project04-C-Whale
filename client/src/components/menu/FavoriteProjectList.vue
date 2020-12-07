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
        :to="`/project/${favoriteProjectInfo.id}`"
      >
        <v-list-item-icon class="mr-1">
          <v-icon small :color="favoriteProjectInfo.color">mdi-circle</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-3">
          <v-list-item-title class="font-14">
            {{ favoriteProjectInfo.title }} <span>{{ favoriteProjectInfo.taskCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>
  </div>
</template>

<script>
export default {
  props: {
    managedProject: Object,
    taskCount: Number,
    favoriteProjectInfos: Array,
  },
};
</script>

<style lang="scss">
.font-14 {
  font-size: 14px;
}
</style>
