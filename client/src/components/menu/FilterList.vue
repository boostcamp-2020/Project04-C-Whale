<template>
  <v-list-group :value="false" sub-group active-class="list-active">
    <template v-slot:activator>
      <v-hover v-slot="{ hover }">
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="font-14">필터</v-list-item-title>
          </v-list-item-content>
          <v-list-item-icon :class="{ 'd-none': !hover }">
            <v-icon>mdi-plus</v-icon>
          </v-list-item-icon>
        </v-list-item>
      </v-hover>
    </template>
    <v-list-item-group>
      <v-list-item v-for="priority in priorities" :key="priority.id">
        <v-list-item-icon class="mr-4">
          <v-icon color="red">mdi-flag</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title class="font-14">{{ priority.title }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>
  </v-list-group>
</template>

<script>
export default {
  props: {
    priorities: Array,
  },
};
</script>
