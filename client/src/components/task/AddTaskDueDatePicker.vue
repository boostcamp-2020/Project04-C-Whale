<template>
  <v-menu :offset-y="true">
    <template v-slot:activator="{ on }">
      <v-btn depressed color="normal" v-on="on" width="120" class="mr-1">
        기한:{{ dateStringToKorean(value) }}
      </v-btn>
    </template>

    <v-date-picker @input="$emit('input', $event)" :value="value" />
  </v-menu>
</template>

<script>
export default {
  props: {
    value: String,
  },
  methods: {
    dateStringToKorean(date) {
      const parsedDate = new Date(date);
      return `${parsedDate.getMonth() + 1}월 ${parsedDate.getDate()}일`;
    },
  },
};
</script>
