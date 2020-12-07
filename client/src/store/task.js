import taskAPI from "../api/task";
import { isToday } from "@/utils/date";

const state = {
  newTask: {},
  tasks: [],
  currentTask: {},
};

const getters = {
  currentTask: (state) => state.currentTask,
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
      commit("SET_ERROR_ALERT", err.response);
      // alert("작업 전체 조회 요청 실패");
    }
  },
  startDragTask({ commit }, { task }) {
    commit("SET_DRAGGING_TASK", task);
  },
  async fetchCurrentTask({ commit }, taskId) {
    try {
      const { data: task } = await taskAPI.getTaskById(taskId);
      commit("SET_CURRENT_TASK", task);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
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
