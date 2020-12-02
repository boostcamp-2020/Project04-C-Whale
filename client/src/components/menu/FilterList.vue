<template>
  <v-list-group :value="true" no-action sub-group>
    <template v-slot:activator>
      <v-list-item-content>
        <v-list-item-title>필터</v-list-item-title>
      </v-list-item-content>
    </template>
    <v-list-item v-for="priority in priorities" :key="priority.id">
      <v-list-item-content>
        <v-list-item-title>{{ priority.title }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-list-group>
</template>

<script>
export default {
  props: {
    priorities: Array,
  },
};
</script>
