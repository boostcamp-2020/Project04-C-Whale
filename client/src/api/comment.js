import myAxios from "./myAxios";

const labelAPI = {
  getAllComments(taskId) {
    return myAxios.get(`/task/${taskId}/comment`);
  },
  createComment(data) {
    return myAxios.post(`/task/${data.taskId}/comment`, data);
  },
};

export default labelAPI;
