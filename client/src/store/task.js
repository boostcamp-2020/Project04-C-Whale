import taskAPI from "../api/task";
import { isToday } from "@/utils/date";

const state = {
  newTask: {},
  tasks: [],
  currentTask: {},
};

const getters = {
  currentTask: (state) => state.currentTask,
  todayTaskCount: (state) => state.tasks.filter((task) => isToday(task.dueDate)).length,
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
  async fetchCurrentTask({ commit }, taskId) {
    try {
      const { data: task } = await taskAPI.getTaskById(taskId);
      commit("SET_CURRENT_TASK", task);
    } catch (err) {
      alert("작업 상세 조회 요청 실패");
    }
  },
};

const mutations = {
  SET_TASKS: (state, tasks) => (state.tasks = tasks),
  SET_CURRENT_TASK: (state, currentTask) => (state.currentTask = currentTask),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
