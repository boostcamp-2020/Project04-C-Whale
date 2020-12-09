import commentAPI from "@/api/comment";

const SUCCESS_MESSAGE = "ok";

const state = {
  comments: [],
  commentCounts: 0,
};

const getters = {
  comments: (state) => state.comments,
  commentCounts: (state) => state.comments.length,
};

const actions = {
  async fetchComments({ commit }, taskId) {
    try {
      const { data: comments } = await commentAPI.getAllComments(taskId);
      comments.sort((comment1, comment2) => (comment1.createdAt > comment2.createdAt ? 1 : -1));
      commit("SET_COMMENTS", comments);
      commit("SET_COMMENT_COUNTS", comments.length);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async addComment({ commit, dispatch }, comment) {
    try {
      const { data } = await commentAPI.createComment(comment);
      if (data.message !== SUCCESS_MESSAGE) {
        throw new Error();
      }

      await dispatch("fetchComments", comment.taskId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },

  async updateComment({ commit, dispatch }, comment) {
    try {
      const { data } = await commentAPI.updateComment(comment);
      if (data.message !== SUCCESS_MESSAGE) {
        throw Error;
      }
      await dispatch("fetchComments", comment.taskId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  async deleteComment({ commit, dispatch }, comment) {
    try {
      const { data } = await commentAPI.deleteComment(comment);
      if (data.message !== SUCCESS_MESSAGE) {
        throw Error;
      }

      await dispatch("fetchComments", comment.taskId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
};

const mutations = {
  SET_COMMENTS: (state, comments) => (state.comments = comments),
  SET_COMMENT_COUNTS: (state, counts) => (state.commentCounts = counts),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
