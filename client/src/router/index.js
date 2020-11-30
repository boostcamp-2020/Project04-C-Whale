import Vue from "vue";
import VueRouter from "vue-router";
import Login from "../views/Login.vue";
import Today from "../views/Today.vue";
import Project from "../views/Project.vue";
import Task from "../views/Task.vue";
import Home from "../views/Home.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/login",
    name: "Login",
    component: Login,
  },
  {
    path: "/",
    name: "Home",
    component: Home,
    children: [
      {
        path: "today",
        name: "Today",
        component: Today,
      },
      {
        path: "project/:projectId",
        name: "Project",
        component: Project,
      },
      {
        path: "task/:taskId",
        name: "Task",
        component: Task,
      },
    ],
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
