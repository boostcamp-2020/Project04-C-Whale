import projectAPI from "../api/project";
import taskAPI from "../api/task";

const state = {
  currentProject: {
    id: "",
    title: "",
    isList: null,
    sections: [],
  },
  projectInfos: [],
};

const getters = {
  currentProject: (state) => state.currentProject,
  projectInfos: (state) => state.projectInfos,
  managedProject: (state) => state.projects.filter((project) => project.title === "관리함"),
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
        throw new Error();
      }

      await dispatch("fetchCurrentProject", projectId);
    } catch (err) {
      alert("프로젝트 조회 요청 실패");
    }
  },
  async fetchProjectInfos({ commit }) {
    try {
      const { data: projects } = await projectAPI.getProjects();

      commit("setProjects", projects);
    } catch (err) {
      alert("프로젝트 전체 정보 조회 요청 실패");
    }
  },
};

const mutations = {
  //TODO: function vs arrow-function style-guide 보고 통일하기
  setCurrentProject: (state, currentProject) => (state.currentProject = currentProject),
  setProjects: (state, projects) => (state.projects = projects),
  // newTodo: (state, todo) => state.todos.unshift(todo),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
