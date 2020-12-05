<template>
  <div class="project-container">
    <div class="project-header">
      <v-list-item>
        <v-list-item-content class="text-h5">
          <updatable-title
            v-if="project.title"
            :originalTitle="project.title"
            :parent="project"
            type="project"
          />
        </v-list-item-content>

        <v-menu :offset-y="true">
          <template v-slot:activator="{ on }">
            <v-list-item-action>
              <v-btn icon v-on="on">
                <v-icon>mdi-dots-horizontal</v-icon>
              </v-btn>
            </v-list-item-action>
          </template>
          <v-list>
            <v-list-item> 섹션 추가 </v-list-item>
          </v-list>
        </v-menu>
      </v-list-item>
    </div>
    <SectionContainer
      v-for="section in project.sections"
      :key="section.id"
      :section="section"
      :draggingTask="draggingTask"
      @taskDragStart="taskDragStart"
      class="mb-5"
    />
  </div>
</template>

<script>
import { mapActions } from "vuex";
import SectionContainer from "@/components/project/SectionContainer";
import UpdatableTitle from "@/components/common/UpdatableTitle";

export default {
  props: {
    project: Object,
  },
  data() {
    return {
      projectId: this.$route.params.projectId,
      draggingTask: {},
    };
  },
  methods: {
    ...mapActions(["updateTaskToDone"]),
    taskDragStart(task) {
      this.draggingTask = task;
    },
  },
  components: {
    UpdatableTitle,
    SectionContainer,
  },
};
</script>

<style>
.project-header {
  min-width: 450px;
}

.project-container {
  width: 100%;
  max-width: 600px;
}

.v-dialog {
  max-width: 80%;
  min-height: 80%;
  background-color: white;
}
</style>
