import myAxios from "./myAxios";

const taskAPI = {
  createTask({ projectId, sectionId, ...data }) {
    return myAxios.POST(`/project/${projectId}/section/${sectionId}/task`, data);
  },
  updateTask(taskId, data) {
    return myAxios.PATCH(`/task/${taskId}`, data);
  },
};

export default taskAPI;
