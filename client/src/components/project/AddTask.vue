<template>
  <div>
    <div v-if="show">
      <form @submit.prevent="">
        <input type="text" v-model="title" placeholder="할일을 입력하세요" />
        <v-btn type="submit" depressed color="primary">+ 작업 추가</v-btn>
        <v-btn @click="show = !show" text color="primary">취소</v-btn>
      </form>
    </div>
    <div v-if="!show">
      <v-btn @click="show = !show" text color="primary">+ 작업 추가</v-btn>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      show: false,
      title: "",
      // task: {
      //   title: "",
      // },
    };
  },
};
</script>

<style></style>
