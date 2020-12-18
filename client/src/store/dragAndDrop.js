const state = {
  draggingTask: {},
  dropTargetContainer: {},
  draggingSection: {},
};

const getters = {
  draggingTask: (state) => state.draggingTask,
  dropTargetContainer: (state) => state.dropTargetContainer,
  draggingSection: (state) => state.draggingSection,
};

const mutations = {
  SET_DRAGGING_TASK: (state, task) => {
    state.draggingTask = task;
  },
  SET_DROP_TARGET_CONTAINER: (state, newDropTargetContainer) => {
    state.dropTargetContainer = newDropTargetContainer;
  },
  SET_DRAGGING_SECTION: (state, section) => {
    state.draggintSection = section;
  },
};

export default {
  state,
  getters,
  mutations,
};
