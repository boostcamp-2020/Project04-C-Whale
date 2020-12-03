<template>
  <!-- <v-dialog v-model="dialog" :retain-focus="false" @click:outside="hideTaskModal()"> -->
  <v-flex>
    <v-list-item class="flex-column">
      <v-list-item-group class="d-flex">
        <v-list-item-title>
          <div class="task_detail-project_title">{{ projectTitle }}</div>
        </v-list-item-title>
        <v-btn icon @click="hideTaskModal()">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-list-item-group>
      <div>{{ task }} hi!!</div>
    </v-list-item>
  </v-flex>
  <!-- </v-dialog> -->
</template>

<script>
export default {
  props: {
    task: Object,
    projectTitle: String,
  },

  methods: {
    hideTaskModal() {
      this.$emit("hideTaskModal");
    },
  },
  computed: {},
  created() {},
  mounted() {},
};
</script>

<style>
.v-list-item {
  align-items: initial;
}
</style>
