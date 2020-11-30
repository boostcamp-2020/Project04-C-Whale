import axios from "axios";

const state = {
  projectInfos: [],
};

const getters = {
  projectInfos: (state) => state.projectInfos,
};

const actions = {
  async fetchProjectInfos({ commit }) {
    const response = await axios.get("http://localhost:3000/api/project");
    console.log(response);
    // commit("setTodos", response.data);
    commit();
  },
};

const mutations = {
  setProjectInfos: (state, projectInfos) => (state.projectInfos = projectInfos),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
