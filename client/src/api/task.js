import myAxios from "./myAxios";

const taskAPI = {
  createTask(data) {
    return myAxios.post(`/task`, data)
  },
  getAllTasks() {
    return myAxios.get("/task");
  },
  getTaskById(taskId) {
    return myAxios.get(`/task/${taskId}`);
  },
  updateTask(taskId, data) {
    return myAxios.patch(`/task/${taskId}`, data);
  },
  updateChildTaskPosition(taskId, data) {
    return myAxios.patch(`/task/${taskId}/position`, data);
  },
  deleteTask(taskId) {
    return myAxios.delete(`/task/${taskId}`);
  },
};

export default taskAPI;
