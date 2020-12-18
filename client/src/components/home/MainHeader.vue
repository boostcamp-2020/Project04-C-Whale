<template>
  <v-container>
    <v-navigation-drawer class="left-menu px-4 py-4" v-model="drawer" app>
      <left-menu></left-menu>
    </v-navigation-drawer>
    <v-app-bar class="header whaleGreen" dense flat app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-app-bar-nav-icon @click="goHome" text>
        <v-icon>mdi-home</v-icon>
      </v-app-bar-nav-icon>

      <Search />
      <v-spacer></v-spacer>
      <v-app-bar-nav-icon @click="toggleQuickAdd" text>
        <v-icon> mdi-plus </v-icon>
      </v-app-bar-nav-icon>

      <v-dialog v-model="showQuickAdd" content-class="dialog" width="500">
        <v-card class="pa-3">
          <AddTask @done="toggleQuickAdd" :initialShow="true" type="quick" />
        </v-card>
      </v-dialog>

      <v-menu :offset-y="true">
        <template v-slot:activator="{ on }">
          <v-app-bar-nav-icon v-on="on" text>
            <v-icon> mdi-account </v-icon>
          </v-app-bar-nav-icon>
        </template>
        <v-list>
          <v-list-item class="d-block">
            <span class="d-inline-block font-14">{{ user.name }}</span>
            <v-list-item-title class="font-14"> {{ user.email }}</v-list-item-title>
          </v-list-item>
          <v-list-item>
            <v-switch
              @click.stop
              v-model="darkMode"
              :label="darkMode ? '다크모드 해제' : '다크모드 설정'"
              class="mt-0"
              hide-details
            ></v-switch>
          </v-list-item>
          <v-list-item @click="logout">
            <v-list-item-icon>
              <v-icon>mdi-logout</v-icon>
            </v-list-item-icon>
            <v-list-item-title class="font-14">로그아웃</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
  </v-container>
</template>

<script>
import Search from "@/components/home/MainHeaderSearchTask";
import LeftMenu from "@/components/home/menu/LeftMenu";
import AddTask from "@/components/task/AddTask";
import { mapActions, mapState } from "vuex";

export default {
  components: {
    Search,
    LeftMenu,
    AddTask,
  },
  data() {
    return {
      drawer: null,
      showQuickAdd: false,
      darkMode: JSON.parse(localStorage.getItem("darkMode")) || false,
    };
  },
  computed: {
    ...mapState({ user: (state) => state.auth.user }),
  },
  watch: {
    darkMode() {
      this.$vuetify.theme.dark = this.darkMode;
      localStorage.setItem("darkMode", this.darkMode);
    },
  },
  created() {
    this.$vuetify.theme.dark = this.darkMode;
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

.add-task-quick {
  max-width: 400px !important;
}

.dialog {
  overflow-y: visible !important;
}

.font-12 {
  font-size: 12px;
}

$navigation-drawer-border-width: 0px;
</style>
