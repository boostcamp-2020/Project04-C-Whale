<template>
  <v-container>
    <v-navigation-drawer class="left-menu px-4 py-4 grey lighten-5" v-model="drawer" app>
      <left-menu></left-menu>
    </v-navigation-drawer>
    <v-app-bar class="header" dense flat app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-app-bar-nav-icon @click="goHome" text>
        <v-icon>mdi-home</v-icon>
      </v-app-bar-nav-icon>

      <Search />
      <v-spacer></v-spacer>
      <v-app-bar-nav-icon @click="toggleQuickAdd" text>
        <v-icon> mdi-plus </v-icon>
      </v-app-bar-nav-icon>

      <v-dialog v-model="showQuickAdd">
        <v-card>
          <AddTask />
        </v-card>
      </v-dialog>

      <v-menu :offset-y="true">
        <template v-slot:activator="{ on }">
          <v-app-bar-nav-icon v-on="on" text>
            <v-icon> mdi-account </v-icon>
          </v-app-bar-nav-icon>
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
    goHome() {
      this.$router.push("/today").catch(() => {});
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

$navigation-drawer-border-width: 0px;
</style>
