import commentAPI from "@/api/comment";

const state = {
  comments: [],
};

const getters = {
  comments: (state) => state.comments,
  //   commentsCount: (state) => {
  //     return state.tasks.reduce((acc, task) => acc + task.tasks.length, state.tasks.length);
  //   },
};

const actions = {
  async fetchComments({ commit }, taskId) {
    try {
      const { data: comments } = await commentAPI.getAllComments(taskId);
      // console.log(data);
      commit("SET_COMMENTS", comments);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
      //   alert("작업 전체 조회 요청 실패");
    }
  },
  async addComment({ commit, dispatch }, comment) {
    try {
      const { data } = await commentAPI.createComment(comment);
      if (data.message !== "ok") {
        throw new Error();
      }

      await dispatch("fetchComments", comment.taskId);
    } catch (err) {
      commit("SET_ERROR_ALERT", err.response);
    }
  },
  //   async fetchUpdateComment({ commit }, comment) {
  //     try {
  //       //   const { data: comment } = await commentAPI.getTaskById(taskId, commentId);
  //       //   commit("SET_CURRENT_TASK", task);
  //     } catch (err) {
  //       commit("SET_ERROR_ALERT", err.response);
  //     }
  //   },
};

const mutations = {
  SET_COMMENTS: (state, comments) => (state.comments = comments),

  //   UPDATE_COMMENT: (state, comment) => (state.comments.find(comment => comment.id) = comment);
  //   DELETE_COMMENT: (state, commentId) => delete state.comments.find((comment) => comment.id === commentId),
};

export default {
  state,
  getters,
  actions,
  mutations,
};
