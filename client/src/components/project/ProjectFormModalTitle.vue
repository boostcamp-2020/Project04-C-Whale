<template>
  <v-text-field
    @input="$emit('input', $event)"
    :value="value"
    label="프로젝트 이름"
    class="mb-0 font-weight-bold"
  ></v-text-field>
</template>

<script>
export default {
  props: {
    value: String,
  },
};
</script>

<style scoped>
.v-text-field input {
  margin-bottom: 0;
}
</style>
