import Vue from "vue";
import VueRouter from "vue-router";
import Login from "../views/Login.vue";
import Today from "../views/Today.vue";
import Project from "../views/Project.vue";
import Task from "../views/Task.vue";
import Home from "../views/Home.vue";
import userAPI from "@/api/user";

Vue.use(VueRouter);

const requireAuth = () => async (from, to, next) => {
  try {
    await userAPI.authorize();
    return next();
  } catch (err) {
    return next("/login");
  }
};

const redirectHome = () => async (from, to, next) => {
  try {
    await userAPI.authorize();
    return next("/");
  } catch (err) {
    return next();
  }
};

const routes = [
  {
    path: "/login",
    name: "Login",
    component: Login,
    beforeEnter: redirectHome(),
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
        beforeEnter: requireAuth(),
      },
      {
        path: "project/:projectId",
        name: "Project",
        component: Project,
        beforeEnter: requireAuth(),
      },
      {
        path: "task/:taskId",
        name: "Task",
        component: Task,
        beforeEnter: requireAuth(),
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
