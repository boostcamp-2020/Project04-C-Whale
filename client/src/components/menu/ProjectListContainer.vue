<template>
  <v-list-group :value="false" sub-group active-class="list-active">
    <template v-slot:activator>
      <v-hover v-slot="{ hover }">
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="font-14">프로젝트</v-list-item-title>
          </v-list-item-content>
          <v-list-item-icon :class="{ 'd-none ': !hover }" @click="openModalEvent">
            <v-icon>mdi-plus</v-icon>
          </v-list-item-icon>
        </v-list-item>
      </v-hover>
    </template>
    <v-list-item-group active-class="list-active">
      <v-list-item
        v-for="project in projectInfos"
        :key="project.id"
        :to="`/project/${project.id}`"
        class="pl-8"
        active-class="font-weight-bold list-active"
      >
        <v-list-item-icon class="mr-4">
          <v-icon :color="project.color">mdi-circle</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-4">
          <v-list-item-title class="font-14"
            >{{ project.title }}
            <span class="task-count">{{ project.taskCount }}</span></v-list-item-title
          >
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        @click.stop="dialog = true"
        inactive
        class="add-btn"
        exact-active-class="list-active"
      >
        <v-list-item-icon class="mr-4">
          <v-icon color="whaleGreen">mdi-plus</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title class="font-14">프로젝트 추가 </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>

    <AddProjectModal :dialog="dialog" v-on:handleModal="dialog = !dialog" />
  </v-list-group>
</template>

<script>
import AddProjectModal from "@/components/project/AddProjectModal.vue";

export default {
  props: {
    projectInfos: Array,
  },
  components: {
    AddProjectModal,
  },
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    openModalEvent(e) {
      e.stopPropagation();
      this.dialog = true;
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
</style>
