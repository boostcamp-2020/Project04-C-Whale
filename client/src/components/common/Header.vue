<template>
  <v-container>
    <v-navigation-drawer class="left-menu px-4 py-4 grey lighten-5" v-model="drawer" app>
      <left-menu></left-menu>
    </v-navigation-drawer>
    <v-app-bar class="header whaleGreen" dense flat app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>할고래DO</v-toolbar-title>
      <Search />

      <v-btn @click="toggleQuickAdd" text>
        <v-icon color="white" class="icon"> mdi-plus </v-icon>
      </v-btn>

      <v-dialog v-model="showQuickAdd" width="500">
        <v-card class="pa-3">
          <AddTask initialShow="true"/>
        </v-card>
      </v-dialog>

      <v-menu :offset-y="true">
        <template v-slot:activator="{ on }">
          <v-btn text v-on="on">
            <v-icon color="white"> mdi-account </v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item @click="logout">
            <!-- <v-list-item-icon>
              <v-icon color="blue">mdi-inbox</v-icon>
            </v-list-item-icon> -->
            <v-list-item-title>로그아웃</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
  </v-container>
</template>

<script>
import Search from "@/components/task/Search";
import LeftMenu from "@/components/menu/LeftMenu";
import AddTask from "@/components/project/AddTask";
import { mapActions } from "vuex";

export default {
  data: () => ({
    drawer: null,
    showQuickAdd: false,
  }),
  components: {
    Search,
    LeftMenu,
    AddTask,
  },
  methods: {
    ...mapActions(["logout"]),
    toggleQuickAdd() {
      this.showQuickAdd = !this.showQuickAdd;
    },
  },
};
</script>

<style lang="scss" scoped>
.header {
  left: 0px !important;
  padding-left: 2%;
  padding-right: 2%;
}
.left-menu {
  top: 48px !important;
  box-shadow: none !important;
  border: 0px none !important;
}
.v-btn {
  padding: 10px 10px !important;
  min-width: 0 !important;
}

.add-task-quick {
  max-width: 400px !important;
}

$navigation-drawer-border-width: 0px;
</style>
