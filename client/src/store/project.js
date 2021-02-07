import projectAPI from "@/api/project";
import router from "@/router";

const state = {
  currentProject: {
    id: "",
    title: "",
    isList: null,
    sections: [],
  },
  projectInfos: [],
  projectList: {},
};

const getters = {
  currentProject: (state) => state.currentProject,
  projectInfos: (state) => state.projectInfos,
  projectInfoById: (state) => (id) => {
    return state.projectInfos.find((project) => project.id === id);
  },
  namedProjectInfos: (state) => {
    const managedProject = [...state.projectInfos].sort(
      (projectA, projectB) => new Date(projectA.createdAt) - new Date(projectB.createdAt)
    )[0];
    return state.projectInfos.filter(
      (project) => project.id !== managedProject.id && !project.isFavorite
    );
  },
  favoriteProjectInfos: (state) => {
    const managedProject = [...state.projectInfos].sort(
      (projectA, projectB) => new Date(projectA.createdAt) - new Date(projectB.createdAt)
    )[0];
    return state.projectInfos.filter(
      (project) => project.isFavorite && project.id !== managedProject.id
    );
  },
  managedProject: (state) => {
    const projectInfoSorted = [...state.projectInfos].sort(
      (projectA, projectB) => new Date(projectA.createdAt) - new Date(projectB.createdAt)
    );
    return projectInfoSorted[0];
  },
  projectList: (state) => state.projectList,
};

const mutations = {
  SET_CURRENT_PROJECT: (state, currentProject) => {
    const newlyFetchedProject = {};
    newlyFetchedProject[currentProject.id] = currentProject;
    state.projectList = { ...state.projectList, ...newlyFetchedProject };
    state.currentProject = currentProject;
  },
  SET_PROJECT_INFOS: (state, projectInfos) => (state.projectInfos = projectInfos),
  ADD_TASK_COUNT: (state, projectId) => {
    const copyed = [...state.projectInfos];
    copyed.find((projectInfo) => projectInfo.id === projectId).taskCount += 1;
    state.projectInfos = [...copyed];
  },
  SUBTRACT_TASK_COUNT: (state, projectId) => {
    const copyed = [...state.projectInfos];
    copyed.find((projectInfo) => projectInfo.id === projectId).taskCount -= 1;
    state.projectInfos = [...copyed];
  },
};

const actions = {
  async fetchCurrentProject({ commit }, projectId) {
    try {
      const {
        data: { project },
      } = await projectAPI.getProjectById(projectId);

      commit("SET_CURRENT_PROJECT", project);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateProjectTitle({ dispatch, commit }, { projectId, title }) {
    try {
      await projectAPI.updateProject(projectId, { title });
      await dispatch("fetchCurrentProject", projectId);
      await dispatch("fetchProjectInfos");
      await dispatch("fetchAllTasks");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateProject({ dispatch, commit }, { projectId, data }) {
    try {
      await projectAPI.updateProject(projectId, data);
      await dispatch("fetchProjectInfos");
      await dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "프로젝트가 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async deleteProject({ dispatch, commit }, { projectId }) {
    try {
      await projectAPI.deleteProject(projectId);
      await dispatch("fetchProjectInfos");
      await dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "프로젝트가 삭제되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async addSection({ dispatch, commit }, { projectId, section }) {
    try {
      await projectAPI.createSection(projectId, {
        title: section.title,
      });
      await dispatch("fetchCurrentProject", projectId);

      commit("SET_SUCCESS_ALERT", "섹션이 추가되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateSectionTitle({ dispatch, commit }, { projectId, sectionId, title }) {
    try {
      await projectAPI.updateSection(projectId, sectionId, { title });
      await dispatch("fetchCurrentProject", projectId);
      await dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "섹션이 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async fetchProjectInfos({ commit }) {
    try {
      const {
        data: { projectInfos },
      } = await projectAPI.getProjects();

      commit("SET_PROJECT_INFOS", projectInfos);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async addProject({ dispatch, commit }, data) {
    try {
      const response = await projectAPI.createProject(data);
      await dispatch("fetchProjectInfos");

      commit("SET_SUCCESS_ALERT", "프로젝트가 생성되었습니다.");
      router.push("/project/" + response.data.projectId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async changeSectionPosition({ dispatch, commit }, { projectId, orderedSections }) {
    try {
      await projectAPI.updateSectionPosition(projectId, {
        orderedSections,
      });
      await dispatch("fetchCurrentProject", projectId);

      commit("SET_SUCCESS_ALERT", "섹션 위치가 변경되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
