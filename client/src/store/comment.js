import commentAPI from "@/api/comment";

const actions = {
  async addComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.createComment(comment);
      await dispatch("fetchAllTasks");

      commit("SET_SUCCESS_ALERT", "댓글이 생성되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.updateComment(comment);
      await dispatch("fetchAllTasks");
      commit("SET_SUCCESS_ALERT", "댓글이 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async deleteComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.deleteComment(comment);
      await dispatch("fetchAllTasks");
      commit("SET_SUCCESS_ALERT", "댓글이 삭제되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
};

export default {
  actions,
};
