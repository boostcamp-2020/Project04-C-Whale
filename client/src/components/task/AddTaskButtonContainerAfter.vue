<template>
  <v-flex>
    <v-btn
      type="submit"
      depressed
      color="primary"
      class="text--white"
      :disabled="task.title.length === 0"
      >+ 작업 추가</v-btn
    >
    <v-btn @click="$emit('closeForm')" text color="whaleGreen">취소</v-btn>
  </v-flex>
</template>

<script>
export default {
  props: {
    task: Object,
  },
};
</script>

<style>
.add-button-container {
  display: flex;
  margin-top: 6px;
  flex-wrap: wrap;
}
</style>
