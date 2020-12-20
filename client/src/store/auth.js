import router from "@/router/index.js";
import userAPI from "@/api/user.js";

const state = {
  user: {
    id: "",
    name: "",
    email: "",
  },
  isAuth: false,
};

const mutations = {
  SET_USER(state, user) {
    state.user = {
      id: user.id,
      name: user.name,
      email: user.email,
    };
    state.isAuth = true;
  },
  LOGOUT() {
    localStorage.removeItem("token");
    location.replace("/login");
    return;
  },
};

const actions = {
  async checkUser({ commit }) {
    try {
      const {
        data: { user },
      } = await userAPI.authorize();
      commit("SET_USER", user);

      if (location.pathname === "/" || location.pathname === "/login") {
        router.replace("/today").catch(() => {});
        return;
      } else {
        router.replace(location.pathname).catch(() => {});
        return;
      }
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
      router.replace("/login").catch(() => {});
      return;
    }
  },

  logout({ commit }) {
    commit("LOGOUT");
  },
};

export default {
  state,
  mutations,
  actions,
};
