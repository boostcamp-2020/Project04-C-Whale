<template>
  <v-form class="px-3 py-3" @submit.prevent>
    <div class="commment-form-data">
      <v-text-field
        class="font-14"
        v-model="bookmark"
        label="작업과 관련된 URL을 등록해주세요"
        @keyup.ctrl="copyURL"
      ></v-text-field>
      <v-btn color="primary" class="text--white" :disabled="bookmark.length <= 0">
        북마크추가
      </v-btn>
      <v-btn @click="setBookmark" text color="#777777">
        <v-icon color="primary" dense class="mr-1"> mdi-plus </v-icon>
        현재 웹사이트를 북마크로 추가
      </v-btn>
    </div>
  </v-form>
</template>

<script>
import whaleApi from "@/utils/whaleApi";
import { getMarkDownUrl } from "@/utils/markdown";

export default {
  data() {
    return {
      bookmark: "",
    };
  },
  methods: {
    setBookmark() {
      whaleApi.getCurrentTabUrl(({ title, url }) => {
        this.bookmark = getMarkDownUrl(title, url);
      });
    },
    copyURL(e) {
      if (!e.key === "v") {
        return;
      }
      this.bookmark = getMarkDownUrl("", this.bookmark);
    },
  },
};
</script>

<style lang="scss"></style>
