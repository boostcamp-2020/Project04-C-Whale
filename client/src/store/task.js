import taskAPI from "../api/task";
import { isToday } from "@/utils/date";
import projectAPI from "../api/project";

const state = {
  newTask: {},
  tasks: [],
  currentTask: {},
};

const getters = {
  currentTask: (state) => state.currentTask,
  todayTasks: (state) => state.tasks.filter((task) => isToday(task.dueDate)),
  expiredTasks: (state) => state.tasks.filter((task) => !isToday(task.dueDate)),
  taskCount: (state) => state.tasks.length,
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
      console.log(task);
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
      //commit("ADD_TASK_COUNT", task.projectId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateTaskToDone({ dispatch, commit }, { projectId, taskId }) {
    try {
      await taskAPI.updateTask(taskId, { isDone: true });
      await dispatch("fetchCurrentProject", projectId);
      await dispatch("fetchAllTasks");
      await dispatch("fetchProjectInfos");

      commit("SET_SUCCESS_ALERT", "작업을 완료했습니다.");
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
  startDragTask({ commit }, { task }) {
    commit("SET_DRAGGING_TASK", task);
  },
  async changeTaskPosition({ rootState, dispatch, commit }, { orderedTasks }) {
    const { draggingTask, dropTargetSection } = rootState.dragAndDrop;

    try {
      await taskAPI.updateTask(draggingTask.id, {
        sectionId: dropTargetSection.id,
      });
      await projectAPI.updateTaskPosition(dropTargetSection.projectId, dropTargetSection.id, {
        orderedTasks,
      });
      await dispatch("fetchCurrentProject", dropTargetSection.projectId);
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
