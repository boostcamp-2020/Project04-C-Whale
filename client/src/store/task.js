import taskAPI from "../api/task";
import { isToday, isExpired } from "@/utils/date";
import projectAPI from "../api/project";

const state = {
  newTask: {},
  tasks: [],
  currentTask: {},
};

const getters = {
  currentTask: (state) => state.currentTask,
  todayTasks: (state) => state.tasks.filter((task) => isToday(task.dueDate) && !task.isDone),
  expiredTasks: (state) => state.tasks.filter((task) => isExpired(task.dueDate) && !task.isDone),
  taskCount: (state) => state.tasks.length,
  tasksWithBookmarks: (state) => state.tasks.filter((task) => task.bookmarks.length > 0),
};

const mutations = {
  SET_TASKS: (state, tasks) => (state.tasks = tasks),
  SET_CURRENT_TASK: (state, currentTask) => (state.currentTask = currentTask),
};

const actions = {
  async fetchAllTasks({ commit }) {
    try {
      const {
        data: { tasks },
      } = await taskAPI.getAllTasks();
      commit("SET_TASKS", tasks);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async fetchCurrentTask({ commit }, taskId) {
    try {
      const {
        data: { task },
      } = await taskAPI.getTaskById(taskId);
      commit("SET_CURRENT_TASK", task);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async addTask({ dispatch, commit }, task) {
    try {
      await taskAPI.createTask(task);
      await dispatch("fetchCurrentProject", task.projectId);
      await dispatch("fetchAllTasks");
      await dispatch("fetchProjectInfos");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateTaskToDone({ dispatch, commit }, { projectId, taskId, isDone }) {
    try {
      await taskAPI.updateTask(taskId, { isDone: true });

      // '오늘' 화면에서 호출되었을 경우
      if (projectId !== undefined) {
        await dispatch("fetchCurrentProject", projectId);
      }

      await dispatch("fetchAllTasks");
      await dispatch("fetchProjectInfos");
      if (isDone) {
        commit("SET_SUCCESS_ALERT", "작업을 완료했습니다.");
      }
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateTask({ commit, dispatch }, task) {
    try {
      taskAPI.updateTask(task);
      dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "작업이 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async changeTaskPosition({ rootState, dispatch, commit }, { orderedTasks }) {
    const { draggingTask, dropTargetContainer } = rootState.dragAndDrop;

    try {
      await taskAPI.updateTask(draggingTask.id, {
        sectionId: dropTargetContainer.id,
      });
      await projectAPI.updateTaskPosition(dropTargetContainer.projectId, dropTargetContainer.id, {
        orderedTasks,
      });
      await dispatch("fetchCurrentProject", dropTargetContainer.projectId);
      await dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "작업 위치가 변경되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async changeChildTaskPosition({ rootState, dispatch, commit }, { orderedTasks }) {
    const { draggingTask, dropTargetContainer } = rootState.dragAndDrop;

    try {
      await taskAPI.updateTask(draggingTask.id, {
        sectionId: dropTargetContainer.sectionId,
      });
      await taskAPI.updateChildTaskPosition(dropTargetContainer.id, { orderedTasks });
      await dispatch("fetchCurrentProject", dropTargetContainer.projectId);
      await dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "작업 위치가 변경되었습니다.");
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
