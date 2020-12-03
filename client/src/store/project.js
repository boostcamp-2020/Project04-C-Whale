import projectAPI from "../api/project";
import taskAPI from "../api/task";
import swapArrayItem from "../utils/array-index-swap";

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

  async changeTaskPosition({ dispatch, rootState }, { section, task }) {
    const taskIds = section.tasks.map((task) => task.id);
    const draggingTask = rootState.task.draggingTask;
    console.log(task.position);
    if (task.sectionId === draggingTask.sectionId) {
      swapArrayItem(taskIds, draggingTask.position, task.position);
    } else {
      taskIds.splice(task.position + 1, 0, task.id);
    }

    try {
      await taskAPI.updateTask(draggingTask.id, { sectionId: section.id });

      const { data } = await projectAPI.updateTaskPosition(section.projectId, section.id, {
        orderedTasks: taskIds,
      });

      if (data.message !== "ok") {
        throw new Error();
      }
    } catch (err) {
      alert("위치 변경 실패");
    }

    await dispatch("fetchCurrentProject", section.projectId);
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
