import projectAPI from "../api/project";

const state = {
  currentProject: {
    id: "",
    title: "",
    isList: null,
    sections: [],
  },
};

const getters = {
  currentProject: (state) => state.currentProject,
};

const actions = {
  async fetchCurrentProject({ commit }, projectId) {
    try {
      const { data: project } = await projectAPI.getProjectById(projectId);

      commit("setCurrentProject", project);
    } catch (err) {
      alert("프로젝트 조회 요청 실패");
    }
  },
  // async addTodo({ commit }, title) {
  //   const response = await axios.post("http://jsonplaceholder.typicode.com/todos", {
  //     title,
  //     completed: false,
  //   });

  //   commit("newTodo", response.data);
  // },
};

const mutations = {
  setCurrentProject: (state, currentProject) => (state.currentProject = currentProject),
  // newTodo: (state, todo) => state.todos.unshift(todo),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
