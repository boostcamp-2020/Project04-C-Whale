const state = {
  draggingTask: {},
  dropTargetSection: {},
  draggingSection: {},
};

const getters = {
  draggingTask: (state) => state.draggingTask,
  dropTargetSection: (state) => state.dropTargetSection,
  draggingSection: (state) => state.draggingSection,
};

const mutations = {
  SET_DRAGGING_TASK: (state, task) => {
    state.draggingTask = task;
  },
  SET_DROP_TARGET_SECTION: (state, newDropTargetSection) => {
    state.dropTargetSection = newDropTargetSection;
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
