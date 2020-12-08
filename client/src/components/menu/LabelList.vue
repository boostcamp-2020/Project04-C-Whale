<template>
  <v-list-group :value="false" sub-group active-class="list-active">
    <template v-slot:activator>
      <v-hover v-slot="{ hover }">
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="font-14">라벨</v-list-item-title>
          </v-list-item-content>
          <v-list-item-icon :class="{ 'd-none': !hover }">
            <v-icon>mdi-plus</v-icon>
          </v-list-item-icon>
        </v-list-item>
      </v-hover>
    </template>
    <v-list-item-group>
      <v-list-item v-for="label in labels" :key="label.id">
        <v-list-item-icon class="mr-4">
          <v-icon :color="label.color">mdi-label</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="px-4">
          <v-list-item-title class="font-14">{{ label.title }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>
  </v-list-group>
</template>

<script>
export default {
  props: {
    labels: Array,
  },
};
</script>

<style lang="scss">
.list-active {
  color: black;
}
</style>
