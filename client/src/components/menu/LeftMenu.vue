<template>
  <div>
    <favorite-project-list></favorite-project-list>
    <v-list-group :value="true" no-action sub-group>
      <template v-slot:activator>
        <v-list-item-content>
          <v-list-item-title>프로젝트</v-list-item-title>
        </v-list-item-content>
      </template>
    </v-list-group>
  </div>
</template>

<script>
import FavoriteProjectList from "./FavoriteProjectList";

export default {
  components: {
    "favorite-project-list": FavoriteProjectList,
  },
};
</script>
