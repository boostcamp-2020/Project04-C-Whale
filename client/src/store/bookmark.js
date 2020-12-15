import bookmarkAPI from "@/api/bookmark";

const state = {
  bookmarkMap: {},
};

const getters = {};

const mutations = {
  SET_BOOKMARKS: (state, { bookmarks, taskId }) => {
    const newBookmarks = {};
    newBookmarks[taskId] = bookmarks;
    state.bookmarkMap = { ...state.bookmarkMap, ...newBookmarks };
  },
};

const actions = {
  async fetchBookmarks({ commit }, taskId) {
    try {
      const {
        data: { bookmarks },
      } = await bookmarkAPI.getAllBookmarks(taskId);
      commit("SET_BOOKMARKS", { bookmarks, taskId });
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async createBookmark({ commit, dispatch }, { bookmark, taskId }) {
    try {
      await bookmarkAPI.createBookmark(taskId, bookmark);
      await dispatch("fetchBookmarks", taskId);
      await dispatch("fetchAllTasks");
      commit("SET_SUCCESS_ALERT", "북마크가 생성되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async deleteBookmark({ commit, dispatch }, { taskId, bookmarkId }) {
    try {
      await bookmarkAPI.deleteBookmark(taskId, bookmarkId);
      await dispatch("fetchBookmarks", taskId);
      await dispatch("fetchAllTasks");
      commit("SET_SUCCESS_ALERT", "북마크가 삭제되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
