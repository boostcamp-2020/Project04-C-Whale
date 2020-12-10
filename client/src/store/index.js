import Vue from "vue";
import Vuex from "vuex";
import auth from "./auth";
import project from "./project";
import task from "./task";
import alert from "./alert";
import dragAndDrop from "./dragAndDrop";
import comment from "./comment";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: { auth, project, task, alert, dragAndDrop, comment },
});
