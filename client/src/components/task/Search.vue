<template class="search">
  <v-col cols="6" sm="6" md="3">
    <v-autocomplete
      v-model="model"
      :items="items"
      :loading="isLoading"
      :search-input.sync="search"
      hide-no-data
      hide-selected
      hide-details
      item-text="title"
      item-value="API"
      placeholder="검색"
      prepend-icon="mdi-magnify"
      return-object
      color="black"
    >
      <template v-slot:item="{ item }">
        <v-list-item-title v-text="item.title"></v-list-item-title>
      </template>
    </v-autocomplete>
  </v-col>
</template>

<script>
import taskAPI from "@/api/task.js";

export default {
  data() {
    return {
      show: false,
      titleLimit: 60,
      tasks: [],
      isLoading: false,
      model: null,
      search: null,
      isFocused: false,
    };
  },
  computed: {
    fields() {
      if (!this.model) return [];

      return Object.keys(this.model).map((key) => {
        return {
          key,
          value: this.model[key] || "n/a",
        };
      });
    },
    items() {
      return this.tasks.map((task) => {
        const title =
          task.title.length > this.titleLimit
            ? task.title.slice(0, this.titleLimit) + "..."
            : task.title; // display length 설정

        return { title, ...task };
      });
    },
  },

  watch: {
    model(task) {
      this.$router.push({
        name: "ProjectTaskDetail",
        params: { taskId: task.id, projectId: task.projectId },
      });
    },
    async search() {
      // Items have already been loaded
      // or Items have already been requested
      if (this.tasks.length > 0 || this.isLoading) {
        return;
      }

      this.isLoading = true;

      // Lazily load input items,
      const res = await taskAPI.getAllTasks();
      this.tasks = res.data.tasks;
      this.isLoading = false;
    },
  },
};
</script>

<style lang="scss">
.v-select__slot input {
  margin-bottom: 0;
}
</style>
