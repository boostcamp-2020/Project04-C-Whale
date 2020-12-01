import myAxios from "./myAxios";

const taskAPI = {
  updateTask(taskId, data) {
    return myAxios.PATCH(`/task/${taskId}`, data);
  },
  serachTask(keyword, data) {
    return myAxios.PATCH(`/task/serach?keyword=${keyword}`, data);
  },
};

export default taskAPI;
