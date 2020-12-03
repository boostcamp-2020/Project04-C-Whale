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
  todayProject: {
    id: "",
    count: 0,
  },
};

const getters = {
  currentProject: (state) => state.currentProject,
  todayProject: (state) => state.todayProject,
  namedProjectInfos: (state) => state.projectInfos.filter((project) => project.title !== "관리함"),
  managedProject: (state) => state.projectInfos.find((project) => project.title === "관리함"),
};

const actions = {
  async fetchCurrentProject({ commit }, projectId) {
    try {
      const { data: project } = await projectAPI.getProjectById(projectId);

      commit("SET_CURRENT_PROJECT", project);
    } catch (err) {
      alert("프로젝트 조회 요청 실패");
    }
  },

  async fetchTodayProject({ commit }) {
    try {
      const { data: todayProject } = await projectAPI.getTodayProject();

      commit("SET_TODAY_PROJECT", todayProject);
    } catch (err) {
      alert("오늘의 프로젝트 조회 요청 실패");
    }
  },

  async updateProjectTitle({ dispatch }, { projectId, title }) {
    try {
      const { data } = await projectAPI.updateProject(projectId, { title });

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", projectId);
    } catch (err) {
      alert("프로젝트 수정 요청 실패");
    }
  },

  async updateSectionTitle({ dispatch }, { projectId, sectionId, title }) {
    try {
      const { data } = await projectAPI.updateSection(projectId, sectionId, { title });

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", projectId);
    } catch (err) {
      alert("섹션 수정 요청 실패");
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
      alert("프로젝트 수정 요청 실패");
    }
  },
  async addTask({ dispatch }, task) {
    try {
      const { data } = await taskAPI.createTask(task);

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", task.projectId);
    } catch {
      alert("프로젝트 추가 요청 실패");
    }
  },
  async fetchProjectInfos({ commit }) {
    try {
      const { data: projectInfos } = await projectAPI.getProjects();

      commit("SET_PROJECT_INFOS", projectInfos);
    } catch (err) {
      alert("프로젝트 전체 정보 조회 요청 실패");
    }
  },
};

const mutations = {
  //TODO: function vs arrow-function style-guide 보고 통일하기
  SET_CURRENT_PROJECT: (state, currentProject) => (state.currentProject = currentProject),
  SET_PROJECT_INFOS: (state, projectInfos) => (state.projectInfos = projectInfos),
  SET_TODAY_PROJECT: (state, todayProject) => (state.todayProject = todayProject),
  // newTodo: (state, todo) => state.todos.unshift(todo),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
