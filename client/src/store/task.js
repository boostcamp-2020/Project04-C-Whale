import projectAPI from "../api/project";
import taskAPI from "../api/task";

const state = {
  newTask: {},
  tasks: [],
};

const getters = {};

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

const mutations = {};

export default {
  state,
  getters,
  actions,
  mutations,
};
