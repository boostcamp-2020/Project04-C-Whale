import Vue from "vue";
import Vuex from "vuex";
import auth from "./auth";
import project from "./project";
import menu from "./menu";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: { auth, menu, project },
});
