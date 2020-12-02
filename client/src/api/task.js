import myAxios from "./myAxios";

const taskAPI = {
  searchTask() {
    return myAxios.GET("/task");
  },
  updateTask(taskId, data) {
    return myAxios.PATCH(`/task/${taskId}`, data);
  },
};

export default taskAPI;
