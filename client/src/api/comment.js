import myAxios from "./myAxios";

const commentAPI = {
  getAllComments(taskId) {
    return myAxios.get(`/task/${taskId}/comment`);
  },
  createComment(data) {
    return myAxios.post(`/task/${data.taskId}/comment`, data);
  },
  updateComment(comment) {
    return myAxios.put(`/task/${comment.taskId}/comment/${comment.id}`, {
      content: comment.content,
    });
  },
  deleteComment(comment) {
    return myAxios.delete(`/task/${comment.taskId}/comment/${comment.id}`, comment);
  },
};

export default commentAPI;
