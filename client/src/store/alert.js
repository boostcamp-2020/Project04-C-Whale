import router from "@/router";

const state = {
  alert: {
    message: "",
    type: "",
  },
};

const mutations = {
  SET_ERROR_ALERT(state, { data, status }) {
    if (status === 401) {
      state.alert = { message: "세션이 만료되었습니다", type: "error" };
      router.replace("/login").catch(() => {});
      return;
    } else {
      state.alert = { message: data.message, type: "error" };
    }
  },
  CLEAR_ALERT(state) {
    state.alert = { message: "", type: "" };
  },
  SET_SUCCESS_ALERT(state, message) {
    state.alert = { message, type: "success" };
  },
};

export default {
  state,
  mutations,
};
