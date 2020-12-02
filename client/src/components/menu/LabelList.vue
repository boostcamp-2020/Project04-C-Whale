<template>
  <v-list-group :value="true" no-action sub-group>
    <template v-slot:activator>
      <v-list-item-content>
        <v-list-item-title>라벨</v-list-item-title>
      </v-list-item-content>
    </template>
    <v-list-item v-for="label in labels" :key="label.id">
      <v-list-item-content>
        <v-list-item-title>{{ label.title }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-list-group>
</template>

<script>
export default {
  props: {
    labels: Array,
  },
};
</script>
