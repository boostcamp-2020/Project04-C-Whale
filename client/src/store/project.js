import projectAPI from "../api/project";
import taskAPI from "../api/task";

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
  async updateTaskToDone({ dispatch }, { projectId, taskId }) {
    try {
      const { data } = await taskAPI.updateTask(taskId, { isDone: true });

      if (data.message !== "ok") {
        return;
      }

      await dispatch("fetchCurrentProject", projectId);
    } catch (err) {
      alert("프로젝트 조회 요청 실패");
    }
  },
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
