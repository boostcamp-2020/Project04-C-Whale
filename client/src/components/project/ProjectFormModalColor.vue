<template>
  <v-select
    @change="$emit('change', $event)"
    :items="colors"
    :value="value"
    label="프로젝트 색상"
    class="font-weight-bold"
  >
    <template slot="item" slot-scope="{ item }">
      <v-list-item-group class="color-list-item d-flex">
        <v-list-item-icon>
          <v-icon :color="item.value">mdi-circle</v-icon>
        </v-list-item-icon>
        <v-list-item-content class="py-2">
          <v-list-item-title class="font-14"> {{ item.text }} </v-list-item-title>
        </v-list-item-content>
      </v-list-item-group>
    </template>
  </v-select>
</template>

<script>
import { colors } from "@/utils/color";

export default {
  model: {
    prop: "value",
    event: "change",
  },
  props: {
    value: String,
  },
  data() {
    return {
      colors,
    };
  },
};
</script>
