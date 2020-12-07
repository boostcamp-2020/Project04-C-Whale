import myAxios from "./myAxios";

const labelAPI = {
  getAllComments(taskId) {
    return myAxios.get(`/task/${taskId}/comment`);
  },
  createComment(data) {
    return myAxios.post(`/task/${data.taskId}/comment`, data);
  },
  updateComment(comment) {
    return myAxios.put(`/task/${comment.taskId}/comment/${comment.id}`, comment);
  },
  deleteComment(comment) {
    return myAxios.delete(`/task/${comment.taskId}/comment/${comment.id}`, comment);
  },
};

export default labelAPI;
