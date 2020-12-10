import taskAPI from "../api/task";
import { isToday } from "@/utils/date";

const state = {
  newTask: {},
  tasks: [],
  currentTask: {},
};

const getters = {
  currentTask: (state) => state.currentTask,
  todayTasks: (state) => state.tasks.filter((task) => isToday(task.dueDate)),
  expiredTasks: (state) => state.tasks.filter((task) => !isToday(task.dueDate)),
  taskCount: (state) => {
    return state.tasks.reduce((acc, task) => acc + task.tasks.length, state.tasks.length);
  },
};

const mutations = {
  SET_TASKS: (state, tasks) => (state.tasks = tasks),
  SET_CURRENT_TASK: (state, currentTask) => (state.currentTask = currentTask),
};

const actions = {
  async fetchAllTasks({ commit }) {
    try {
      const {
        data: { tasks },
      } = await taskAPI.getAllTasks();
      commit("SET_TASKS", tasks);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async fetchCurrentTask({ commit }, taskId) {
    try {
      const {
        data: { task },
      } = await taskAPI.getTaskById(taskId);
      commit("SET_CURRENT_TASK", task);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateTask({ commit, dispatch }, task) {
    try {
      taskAPI.updateTask(task);
      dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "작업이 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  startDragTask({ commit }, { task }) {
    commit("SET_DRAGGING_TASK", task);
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
