const state = {
  priorities: [],
};

const getters = {
  priorities: (state) => state.priorities,
};

const mutations = {
  SET_PRIORITIES: (state, priorities) => (state.priorities = priorities),
};

const actions = {
  async fetchPriorities({ commit }) {
    try {
      const priorities = [
        {
          id: "c3bb8b39-cdad-4db4-ac02-ae506d30ba2a",
          title: "우선순위1",
        },
        {
          id: "248d7dd6-9f9b-4bff-b47d-43a8b07c9093",
          title: "우선순위2",
        },
        {
          id: "ac7ac13c-53df-49a3-8617-654e23f3d043",
          title: "우선순위3",
        },
        {
          id: "936f1c1d-e169-47c4-b544-1f8a0aff0a8d",
          title: "우선순위4",
        },
      ];
      commit("SET_PRIORITIES", priorities);
    } catch (err) {
      alert("우선순위 전체 정보 조회 요청 실패");
    }
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
