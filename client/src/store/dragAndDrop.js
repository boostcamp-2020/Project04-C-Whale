const state = {
  draggingTask: {},
  dropTargetContainer: {},
};

const getters = {
  draggingTask: (state) => state.draggingTask,
  dropTargetContainer: (state) => state.dropTargetContainer,
};

const mutations = {
  SET_DRAGGING_TASK: (state, task) => {
    state.draggingTask = task;
  },
  SET_DROP_TARGET_CONTAINER: (state, newDropTargetContainer) => {
    state.dropTargetContainer = newDropTargetContainer;
  },
};

export default {
  state,
  getters,
  mutations,
};
