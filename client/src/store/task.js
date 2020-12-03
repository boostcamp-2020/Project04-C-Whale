import taskAPI from "../api/task";
import { isToday } from "@/utils/date";

const state = {
  newTask: {},
  tasks: [],
  draggingTask: {},
};

const getters = {
  todayTaskCount: (state) => state.tasks.filter((task) => isToday(task.dueDate)).length,
  nextDayTaskCount: (state) => state.tasks.filter((task) => !isToday(task.dueDate)).length,
  draggingTask: (state) => state.draggingTask,
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

  startDragTask({ commit }, { task }) {
    commit("SET_DRAGGING_TASK", task);
  },
};

const mutations = {
  SET_TASKS: (state, tasks) => (state.tasks = tasks),
  SET_DRAGGING_TASK: (state, task) => (state.draggingTask = task),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
