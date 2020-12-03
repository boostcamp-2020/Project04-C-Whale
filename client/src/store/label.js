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
      alert("라벨 전체 정보 조회 요청 실패");
    }
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
