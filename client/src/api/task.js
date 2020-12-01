import myAxios from "./myAxios";

const taskAPI = {
  serachTask() {
    return myAxios.GET("/task");
  },
  updateTask(taskId, data) {
    return myAxios.PATCH(`/task/${taskId}`, data);
  },
};

export default taskAPI;
