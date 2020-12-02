import Vue from "vue";
import VueRouter from "vue-router";
import Login from "@/views/Login.vue";
import Today from "@/views/Today.vue";
import Project from "@/views/Project.vue";
import Task from "@/views/Task.vue";
import Home from "@/views/Home.vue";
import userAPI from "@/api/user";
import TaskDetail from "@/components/task/TaskDetail.vue";

Vue.use(VueRouter);

// TODO: user/me api 2번 호출하는 문제 해결
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
        children: [
          {
            path: "task/:taskId",
            name: "TaskDetail",
            component: TaskDetail,
            // meta: { dialog: false },
          },
        ],
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
