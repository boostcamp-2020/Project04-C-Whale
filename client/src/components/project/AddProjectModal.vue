<template>
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      persistent
      max-width="600"
      class="add-project-dialog"
      @click:outside="sendCloseModalEvent"
    >
      <v-card>
        <v-card-title class="font-weight-bold"> 프로젝트 추가 </v-card-title>
        <v-card-text>
          <v-container class="project-modal">
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <v-text-field
                  v-model="newProject.title"
                  class="mb-0 font-weight-bold"
                  label="프로젝트 이름"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="12" md="12">
                <v-select
                  v-model="newProject.color"
                  :items="colors"
                  label="프로젝트 색상"
                  class="font-weight-bold"
                >
                  <template slot="item" slot-scope="{ item }">
                    <v-list-item-group class="color-list-item d-flex">
                      <v-list-item-icon>
                        <v-icon :color="item.value">mdi-circle</v-icon>
                      </v-list-item-icon>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="font-14">{{ item.text }}</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item-group>
                  </template>
                </v-select>
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
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="black darken-1" text @click="sendCloseModalEvent"> 취소 </v-btn>
          <v-btn
            color="whaleGreen"
            text
            @click="addNewProject"
            :disabled="newProject.title.length == 0"
          >
            추가
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import { colors } from "@/utils/color";
import { mapActions, mapMutations } from "vuex";

export default {
  props: {
    dialog: Boolean,
  },
  data() {
    return {
      newProject: {
        title: "",
        color: null,
        isFavorite: false,
        isList: true,
      },
      colors,
    };
  },
  methods: {
    ...mapActions(["addProject"]),
    ...mapMutations(["SET_ERROR_ALERT"]),
    clearProject() {
      this.newProject = { title: "", color: null, isFavorite: false, isList: true };
    },
    sendCloseModalEvent() {
      this.clearProject();
      this.$emit("handleAddModal");
    },
    addNewProject() {
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
      this.addProject(this.newProject);
      this.clearProject();
      this.$emit("handleAddModal");
    },
  },
};
</script>

<style lang="scss">
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

.v-text-field input {
  margin-bottom: 0;
}
</style>
