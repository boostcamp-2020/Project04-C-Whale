import myAxios from "./myAxios";

const taskAPI = {
  createTask({ projectId, sectionId, ...data }) {
    return myAxios.post(`/project/${projectId}/section/${sectionId}/task`, data);
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
};

export default taskAPI;
