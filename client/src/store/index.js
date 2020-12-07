import Vue from "vue";
import Vuex from "vuex";
import auth from "./auth";
import project from "./project";
import label from "./label";
import priority from "./priority";
import task from "./task";
import alert from "./alert";
import dragAndDrop from "./dragAndDrop";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: { auth, project, label, priority, task, alert, dragAndDrop },
});
