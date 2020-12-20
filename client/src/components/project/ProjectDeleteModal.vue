<template>
  <v-row justify="center">
    <v-dialog v-model="dialog" persistent max-width="600" @click:outside="$emit('closeModal')">
      <v-card>
        <v-card-title> 프로젝트 삭제 </v-card-title>
        <v-card-text> {{ projectInfo.title }}을 삭제하시겠습니까? </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="black darken-1" text @click="$emit('closeModal')"> 취소 </v-btn>
          <v-btn color="whaleGreen" text @click="confirm"> 삭제 </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { mapActions } from "vuex";

export default {
  props: {
    dialog: Boolean,
    projectInfo: Object,
  },
  methods: {
    ...mapActions(["deleteProject"]),
    confirm() {
      this.deleteProject({ projectId: this.projectInfo.id });
      this.$emit("closeModal");
    },
  },
};
</script>

<style lang="scss">
.v-dialog {
  min-height: auto !important;
}
.color-list-item {
  min-height: 36px;
}

.v-text-field input {
  margin-bottom: 0;
}
</style>
