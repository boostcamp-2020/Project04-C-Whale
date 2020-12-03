<template>
  <v-dialog v-model="dialog" @click:outside="hideTaskModal()">
    <v-flex>
      <v-list-item>
        <v-list-item-group>
          <v-list-item-title> </v-list-item-title>
          <div>{{ currentTask }} hi!!</div>
        </v-list-item-group>
      </v-list-item>
    </v-flex>
  </v-dialog>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import UpdatableTitle from "@/components/common/UpdatableTitle";

export default {
  data() {
    return {
      dialog: true,
      taskId: this.$route.params.taskId,
    };
  },

  methods: {
    ...mapActions(["fetchCurrentTask"]),
    hideTaskModal() {
      this.$router.go(-1);
    },
  },
  computed: mapGetters(["currentTask"]),
  created() {
    this.fetchCurrentTask(this.$route.params.taskId);
  },
  components: {
    UpdatableTitle,
  },
};
</script>

<style></style>
