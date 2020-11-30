<template>
  <div>메뉴..</div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {
  name: "Menu",
  methods: {
    ...mapActions(["fetchProjectInfos"]),
  },
  computed: mapGetters(["projectInfos"]),
  created() {
    this.fetchProjectInfos();
  },
};
</script>

<style></style>
