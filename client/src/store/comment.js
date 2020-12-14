import commentAPI from "@/api/comment";

const state = {
  commentsMap: {},
};

const getters = {};

const mutations = {
  SET_COMMENTS: (state, { comments, taskId }) => {
    const newComments = {};
    newComments[taskId] = [...comments];
    state.commentsMap = { ...state.commentsMap, ...newComments };
  },
};

const actions = {
  async fetchAllComments({ commit }, taskId) {
    try {
      const {
        data: { comments },
      } = await commentAPI.getAllComments(taskId);
      commit("SET_COMMENTS", { comments, taskId });
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async addComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.createComment(comment);
      await dispatch("fetchAllComments", comment.taskId);

      commit("SET_SUCCESS_ALERT", "댓글이 생성되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateComment({ commit, dispatch }, comment) {
    try {
      console.log(comment);

      await commentAPI.updateComment(comment);
      await dispatch("fetchAllComments", comment.taskId);
      commit("SET_SUCCESS_ALERT", "댓글이 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async deleteComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.deleteComment(comment);
      await dispatch("fetchAllComments", comment.taskId);
      commit("SET_SUCCESS_ALERT", "댓글이 삭제되었습니다.");
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
