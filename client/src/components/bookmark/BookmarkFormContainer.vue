<template>
  <v-form class="px-3 py-3" @submit.prevent="addBookmark">
    <div class="commment-form-data">
      <v-text-field
        class="font-14"
        v-model="bookmark"
        label="[북마크제목](URL)형식으로 입력해주세요"
        @keyup.ctrl="copyURL"
        :rules="[rules.URL]"
      ></v-text-field>
      <v-btn type="submit" color="primary" class="text--white" :disabled="bookmark.length <= 0">
        북마크추가
      </v-btn>
      <v-btn v-if="isWhale" @click="setBookmark" text color="#777777">
        <v-icon color="primary" dense class="mr-1"> mdi-plus </v-icon>
        현재 웹사이트를 북마크로 추가
      </v-btn>
    </div>
  </v-form>
</template>

<script>
import whaleApi from "@/utils/whaleApi";
import { getMarkDownUrl, isValidURLMarkdown, getBookmark } from "@/utils/markdown";
import { mapActions } from "vuex";

export default {
  data() {
    return {
      bookmark: "",
      isWhale: window.whale ? true : false,
      rules: {
        URL: (value) => {
          return isValidURLMarkdown(value) || "유효하지 않은 형식입니다.";
        },
      },
    };
  },
  methods: {
    ...mapActions(["createBookmark"]),
    setBookmark() {
      if (this.isWhale) {
        whaleApi.getCurrentTabUrl(({ title, url }) => {
          this.bookmark = getMarkDownUrl(title, url);
        });
      }
    },
    copyURL(e) {
      if (!e.key === "v") {
        return;
      }
      this.bookmark = getMarkDownUrl("", this.bookmark);
    },
    addBookmark() {
      const bookmark = getBookmark(this.bookmark);
      this.createBookmark({ bookmark, taskId: this.$route.params.taskId });
      this.bookmark = "";
    },
  },
};
</script>

<style lang="scss"></style>
