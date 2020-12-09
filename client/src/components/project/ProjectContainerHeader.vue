<template>
  <div class="project-header">
    <v-list-item>
      <v-list-item-content class="text-h5">
        <UpdatableTitle
          v-if="project.title"
          :originalTitle="project.title"
          :parent="project"
          type="project"
        />
      </v-list-item-content>

      <v-menu :offset-y="true">
        <template v-slot:activator="{ on }">
          <v-list-item-action class="mr-6">
            <v-btn icon v-on="on">
              <v-icon>mdi-dots-horizontal</v-icon>
            </v-btn>
          </v-list-item-action>
        </template>
        <v-list>
          <v-list-item @click="showAddSection">
            <v-list-item-title>섹션 추가 </v-list-item-title>
          </v-list-item>
          <v-list-item @click="selectListView">
            <v-list-item-title>보기 형태: 목록 </v-list-item-title>
          </v-list-item>
          <v-list-item @click="selectBoardView">
            <v-list-item-title>보기 형태: 보드 </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-list-item>
  </div>
</template>

<script>
import UpdatableTitle from "@/components/common/UpdatableTitle";
export default {
  props: {
    project: Object,
  },
  data: function () {
    return {};
  },
  methods: {
    selectListView() {
      this.$emit("selectListView");
    },
    selectBoardView() {
      this.$emit("selectBoardView");
    },
    showAddSection() {
      this.$emit("showAddSection");
    },
  },
  components: {
    UpdatableTitle,
  },
};
</script>

<style>
.project-header {
  min-width: 440px;
}
</style>
