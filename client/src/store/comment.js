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
      comments.sort((comment1, comment2) => (comment1.updatedAt > comment2.updatedAt ? 1 : -1));
      commit("SET_COMMENTS", comments);
      commit("SET_COMMENT_COUNTS", comments.length);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
      //   alert("작업 전체 조회 요청 실패");
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
      // commit("DELETE_COMMENT", comment.id);
      // commit("DECREASE_COMMENT_COUNTS");
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
};

const mutations = {
  SET_COMMENTS: (state, comments) => (state.comments = comments),
  SET_COMMENT_COUNTS: (state, counts) => (state.commentCounts = counts),
  DECREASE_COMMENT_COUNTS: (state) => state.commentCounts--,
  //   UPDATE_COMMENT: (state, comment) => (state.comments.find(comment => comment.id) = comment);
  DELETE_COMMENT: (state, commentId) => {
    const index = state.comments.indexOf(
      state.comments.find((comment) => comment.id === commentId)
    );
    const comments = state.comments.splice(index, 1);
    this.state.comments = comments;
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
