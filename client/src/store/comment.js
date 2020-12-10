import commentAPI from "@/api/comment";

const state = {
  comments: [],
  commentCounts: 0,
};

const getters = {
  comments: (state) => state.comments,
  commentCounts: (state) => state.comments.length,
};

const mutations = {
  SET_COMMENTS: (state, comments) => (state.comments = comments),
  SET_COMMENT_COUNTS: (state, counts) => (state.commentCounts = counts),
};

const actions = {
  async fetchComments({ commit }, taskId) {
    try {
      const {
        data: { comments },
      } = await commentAPI.getAllComments(taskId);
      comments.sort((comment1, comment2) => (comment1.createdAt > comment2.createdAt ? 1 : -1));
      commit("SET_COMMENTS", comments);
      commit("SET_COMMENT_COUNTS", comments.length);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async addComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.createComment(comment);
      await dispatch("fetchComments", comment.taskId);

      commit("SET_SUCCESS_ALERT", "댓글이 생성되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async updateComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.updateComment(comment);
      await dispatch("fetchComments", comment.taskId);

      commit("SET_SUCCESS_ALERT", "댓글이 수정되었습니다.");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async deleteComment({ commit, dispatch }, comment) {
    try {
      await commentAPI.deleteComment(comment);
      await dispatch("fetchComments", comment.taskId);

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
