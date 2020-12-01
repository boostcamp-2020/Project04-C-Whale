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
          item-text="Description"
          item-value="API"
          placeholder="검색"
          prepend-icon="mdi-magnify"
          return-object
          solo
        ></v-autocomplete>
      </v-card-text>
      <!-- <v-text-field
        @click="show = !show"
        appendIcon="mdi-magnify"
        placeholder="검색"
        solo
      ></v-text-field> -->
    </v-flex>
    <v-container v-if="show">
      <v-list v-for="task in lastSearched" :key="task.id">{{ task.title }}</v-list>
    </v-container>
  </v-input>
</template>

<script>
import router from "@/router/index.js";

export default {
  data() {
    return {
      show: false,
      lastSearched: [
        { id: "1212sdkf-124oij", title: "hi" },
        { id: "12asd-1234", title: "test" },
      ],
      descriptionLimit: 60,
      entries: [],
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
      return this.entries.map((entry) => {
        // TODO : API 연동 후, 변수명 title로 변경, entry에서도 title로 바꿔야한다.
        const Description =
          entry.Description.length > this.descriptionLimit
            ? entry.Description.slice(0, this.descriptionLimit) + "..."
            : entry.Description; // display length 설정

        return { Description, ...entry };
      });
    },
  },

  watch: {
    model(obj) {
      //TODO API 연동 후, obj.id로 바뀌어야한다.
      router.push(`/task/${obj.Description}`).catch(() => {});
    },
    search() {
      // Items have already been loaded
      // or Items have already been requested
      if (this.items.length > 0 || this.isLoading) {
        return;
      }

      this.isLoading = true;

      // Lazily load input items,
      // TODO 여기에 serach 받아와서 표현 & axios로 바꿔야함
      fetch("https://api.publicapis.org/entries")
        .then((res) => res.json())
        .then((res) => {
          const { count, entries } = res;
          this.count = count;
          this.entries = entries;
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => (this.isLoading = false));
    },
  },
};
</script>

<style></style>
