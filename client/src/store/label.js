import labelAPI from "@/api/label";

const state = {
  newLabel: {},
  labels: [],
};

const getters = {
  labels: (state) => state.labels,
};

const mutations = {
  SET_LABELS: (state, labels) => (state.labels = labels),
};

const actions = {
  async fetchLabels({ commit }) {
    try {
      const { data: labels } = await labelAPI.getLabels();

      commit("SET_LABELS", labels);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
