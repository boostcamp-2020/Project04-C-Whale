const state = {
  draggingTask: {},
  dropTargetSection: {},
};

const getters = {
  draggingTask: (state) => state.draggingTask,
  dropTargetSection: (state) => state.dropTargetSection,
};

const actions = {};

const mutations = {
  SET_DRAGGING_TASK: (state, task) => {
    state.draggingTask = task;
  },
  SET_DROP_TARGET_SECTION: (state, newDropTargetSection) => {
    state.dropTargetSection = newDropTargetSection;
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
