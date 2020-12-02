import taskAPI from "../api/task";
import { isToday } from "@/utils/date";

const state = {
  newTask: {},
  tasks: [],
};

const getters = {
  nextDayTaskCount: (state) => state.tasks.filter((task) => !isToday(task.dueDate)).length,
};

const actions = {
  async fetchAllTasks({ commit }) {
    try {
      const tasks = await taskAPI.getTasks();
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
