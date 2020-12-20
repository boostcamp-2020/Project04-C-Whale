<template>
  <v-card-actions>
    <v-spacer></v-spacer>
    <v-btn @click="$emit('closeModal')" color="black darken-1" text> 취소 </v-btn>
    <v-btn
      @click="$emit('submit')"
      color="whaleGreen"
      text
      :disabled="newProject.title.length == 0"
    >
      {{ typeKorean }}
    </v-btn>
  </v-card-actions>
</template>

<script>
export default {
  props: {
    newProject: Object,
    typeKorean: String,
  },
};
</script>
