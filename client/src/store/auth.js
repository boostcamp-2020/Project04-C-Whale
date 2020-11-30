const state = {
  accessToken: null,
};
const mutations = {
  LOGIN(state, { accessToken }) {
    state.accessToken = accessToken;
    localStorage.setItem("token", accessToken);
  },
  LOGOUT(state) {
    state.accessToken = null;
    localStorage.removeItem("token");
  },
};

const actions = {};

export default {
  state,
  actions,
  mutations,
};
