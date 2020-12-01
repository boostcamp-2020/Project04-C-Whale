import projectAPI from "../api/project";
import taskAPI from "../api/task";

const state = {
  newTask: {},
  tasks: [],
};

const getters = {
  todayTasks: (state) => state.tasks.filter(new Date(task.dueDate) < new Date(Date.now()) )
};

const actions = {
  async fetchAllTasks({ commit }) {
    try {
      const tasks = await taskAPI.getTasks();
      commit("setTasks", tasks);
    } catch (err) {
      alert("작업 전체 조회 요청 실패");
    }
  },
};

const mutations = {
  setTasks: (state, tasks) => state.tasks= tasks;
};

export default {
  state,
  getters,
  actions,
  mutations,
};
