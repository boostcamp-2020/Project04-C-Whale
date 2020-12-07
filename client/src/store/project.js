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
  projectList: {},
};

const getters = {
  currentProject: (state) => state.currentProject,
  namedProjectInfos: (state) => state.projectInfos.filter((project) => project.title !== "관리함"),
  managedProject: (state) => state.projectInfos.find((project) => project.title === "관리함"),
  projectList: (state) => state.projectList,
};

const actions = {
  async fetchCurrentProject({ commit }, projectId) {
    try {
      const { data: project } = await projectAPI.getProjectById(projectId);

      commit("SET_CURRENT_PROJECT", project);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async fetchTodayProject({ commit }) {
    try {
      const { data: todayProject } = await projectAPI.getTodayProject();

      commit("SET_TODAY_PROJECT", todayProject);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async updateProjectTitle({ dispatch, commit }, { projectId, title }) {
    try {
      const { data } = await projectAPI.updateProject(projectId, { title });

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", projectId);
      await dispatch("fetchAllTasks");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async updateSectionTitle({ dispatch, commit }, { projectId, sectionId, title }) {
    try {
      const { data } = await projectAPI.updateSection(projectId, sectionId, { title });

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", projectId);
      await dispatch("fetchAllTasks");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async updateTaskToDone({ dispatch, commit }, { projectId, taskId }) {
    try {
      const { data } = await taskAPI.updateTask(taskId, { isDone: true });

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", projectId);
      await dispatch("fetchAllTasks");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async addTask({ dispatch, commit }, task) {
    try {
      const { data } = await taskAPI.createTask(task);

      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchCurrentProject", task.projectId);
      await dispatch("fetchAllTasks");
      commit("ADD_TASK_COUNT", task.projectId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async fetchProjectInfos({ commit }) {
    try {
      const { data: projectInfos } = await projectAPI.getProjects();

      commit("SET_PROJECT_INFOS", projectInfos);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
      // alert("프로젝트 전체 정보 조회 요청 실패");
    }
  },

  async changeTaskPosition({ rootState, dispatch }, { orderedTasks }) {
    const { draggingTask, dropTargetSection } = rootState.dragAndDrop;

    try {
      await taskAPI.updateTask(draggingTask.id, {
        sectionId: dropTargetSection.id,
      });

      const { data } = await projectAPI.updateTaskPosition(
        dropTargetSection.projectId,
        dropTargetSection.id,
        {
          orderedTasks,
        }
      );

      if (data.message !== "ok") {
        throw new Error();
      }
    } catch (err) {
      alert("위치 변경 실패");
    }

    await dispatch("fetchCurrentProject", dropTargetSection.projectId);
    await dispatch("fetchAllTasks");
  },
};

const mutations = {
  SET_CURRENT_PROJECT: (state, currentProject) => {
    const newlyFetchedProject = {};
    newlyFetchedProject[currentProject.id] = currentProject;
    state.projectList = { ...state.projectList, ...newlyFetchedProject };
    state.currentProject = currentProject;
  },
  SET_PROJECT_INFOS: (state, projectInfos) => (state.projectInfos = projectInfos),
  SET_TODAY_PROJECT: (state, todayProject) => (state.todayProject = todayProject),
  ADD_TASK_COUNT: (state, projectId) => {
    const copyed = [...state.projectInfos];
    copyed.find((projectInfo) => projectInfo.id === projectId).taskCount += 1;
    state.projectInfos = [...copyed];
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
