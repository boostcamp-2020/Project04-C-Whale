import myAxios from "./myAxios";

const taskAPI = {
  updateTask(taskId, data) {
    return myAxios.PATCH(`/task/${taskId}`, data);
  },
  getTasks() {
    return myAxios.get("/task/all");
  },
};

export default taskAPI;
