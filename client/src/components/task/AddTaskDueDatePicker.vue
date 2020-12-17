<template>
  <v-menu :offset-y="true">
    <template v-slot:activator="{ on }">
      <v-btn depressed color="normal" v-on="on" width="120" class="mr-1">
        기한:{{ dateStringToKorean(dueDate) }}
      </v-btn>
    </template>
    <v-date-picker @input="pickDueDate" :value="dueDate" />
  </v-menu>
</template>

<script>
export default {
  props: {
    dueDate: String,
  },
  methods: {
    dateStringToKorean(date) {
      const parsedDate = new Date(date);
      return `${parsedDate.getMonth() + 1}월 ${parsedDate.getDate()}일`;
    },

    pickDueDate(date) {
      this.$emit("pickDueDate", date);
    },
  },
};
</script>
