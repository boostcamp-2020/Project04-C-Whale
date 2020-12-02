import taskAPI from "../api/task";
import { isToday } from "@/utils/date";

const state = {
  newTask: {},
  tasks: [],
};

const getters = {
  todayTasks: (state) => state.tasks.filter((task) => isToday(task)),
  expiredTasks: (state) => state.tasks.filter((task) => !isToday(task)),
  taskCount: (state) => {
    return state.tasks.reduce((acc, task) => acc + task.tasks.length, state.tasks.length);
  },
};

const actions = {
  async fetchAllTasks({ commit }) {
    try {
      const { data: tasks } = await taskAPI.getAllTasks();
      commit("SET_TASKS", tasks);
    } catch (err) {
      alert("작업 전체 조회 요청 실패");
    }
  },
};

const mutations = {
  SET_TASKS: (state, tasks) => (state.tasks = tasks),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
