<template>
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      persistent
      max-width="600"
      class="add-project-dialog"
      @click:outside="closeModal"
    >
      <v-card>
        <v-card-title class="font-weight-bold"> 프로젝트 {{ typeKorean }} </v-card-title>
        <v-card-text>
          <v-container class="project-modal">
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <ProjectFormModalTitle v-model="newProject.title" />
              </v-col>

              <v-col cols="12" sm="12" md="12">
                <ProjectFormModalColor v-model="newProject.color" />
              </v-col>

              <v-col cols="12" sm="12" md="12">
                <span class="font-weight-bold">즐겨찾기</span>
                <v-switch
                  v-model="newProject.isFavorite"
                  color="whaleGreen"
                  class="font-weight-bold"
                ></v-switch>
              </v-col>

              <v-col cols="12" sm="12" md="12">
                <span class="font-weight-bold">보기</span>
                <v-radio-group v-model="newProject.isList" row>
                  <v-radio color="whaleGreen" label="목록 " :value="true"></v-radio>
                  <v-radio color="whaleGreen" label="보드" :value="false"></v-radio>
                </v-radio-group>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>

        <ProjectFormModalButtonContainer
          @closeModal="closeModal"
          @submit="submit"
          :newProject="newProject"
          :typeKorean="typeKorean"
        />
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { mapActions, mapMutations } from "vuex";
import ProjectFormModalTitle from "@/components/project/ProjectFormModalTitle";
import ProjectFormModalColor from "@/components/project/ProjectFormModalColor";
import ProjectFormModalButtonContainer from "@/components/project/ProjectFormModalButtonContainer";

const types = {
  ADD: "add",
  UPDATE: "update",
};

export default {
  props: {
    dialog: Boolean,
    type: String,
    projectInfo: Object,
  },
  components: {
    ProjectFormModalTitle,
    ProjectFormModalColor,
    ProjectFormModalButtonContainer,
  },
  data() {
    return {
      newProject: {
        title: this.type === types.UPDATE ? this.projectInfo.title : "",
        color: this.type === types.UPDATE ? this.projectInfo.color : "",
        isFavorite: this.type === types.UPDATE ? this.projectInfo.isFavorite : false,
        isList: this.type === types.UPDATE ? this.projectInfo.isList : true,
      },
      typeKorean: this.type === types.UPDATE ? "수정" : "추가",
    };
  },
  methods: {
    ...mapActions(["addProject", "updateProject"]),
    ...mapMutations(["SET_ERROR_ALERT"]),
    clearProject() {
      this.newProject = { title: "", color: null, isFavorite: false, isList: true };
    },
    closeModal() {
      if (this.type === types.ADD) {
        this.clearProject();
      }

      this.$emit("closeModal");
    },
    submit() {
      const defaultProjectTitle = "관리함";
      if (this.newProject.title === defaultProjectTitle) {
        this.SET_ERROR_ALERT({
          data: { message: "해당 제목으로 프로젝트를 생성할 수 없습니다." },
          status: 406,
        });
        this.title = "";
        return;
      }
      if (!this.newProject.color) {
        this.SET_ERROR_ALERT({
          data: { message: "프로젝트 색상을 지정해주세요" },
          status: 406,
        });
        return;
      }

      if (this.type === types.UPDATE) {
        this.updateProject({
          projectId: this.projectInfo.id,
          data: this.newProject,
        });
      } else {
        this.addProject(this.newProject);
      }

      this.closeModal();
    },
  },
};
</script>

<style lang="scss" scoped>
.v-dialog {
  min-height: auto !important;
}

.project-modal {
  min-width: auto !important;
}

.v-dialog.add-project-dialog {
  width: 100% !important;
}

.color-list-item {
  min-height: 36px;
}
</style>
