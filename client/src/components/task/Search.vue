<template>
  <v-input>
    <v-flex xs12 sm5 md3 ml-5 mt-12>
      <v-card-text>
        <v-autocomplete
          v-model="model"
          :items="items"
          :loading="isLoading"
          :search-input.sync="search"
          color="green"
          hide-no-data
          hide-selected
          item-text="title"
          item-value="API"
          placeholder="검색"
          prepend-icon="mdi-magnify"
          return-object
          solo
        ></v-autocomplete>
      </v-card-text>
    </v-flex>
    <v-container v-if="show">
      <v-list v-for="task in lastSearched" :key="task.id">{{ task.title }}</v-list>
    </v-container>
  </v-input>
</template>

<script>
import router from "@/router/index.js";
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
    model(obj) {
      router.push(`/task/${obj.id}`).catch(() => {});
    },
    async search() {
      // Items have already been loaded
      // or Items have already been requested
      if (this.items.length > 0 || this.isLoading) {
        return;
      }

      this.isLoading = true;

      // Lazily load input items,
      const res = await taskAPI.searchTask();
      this.tasks = res.data.tasks;
      this.isLoading = false;
    },
  },
};
</script>

<style></style>
