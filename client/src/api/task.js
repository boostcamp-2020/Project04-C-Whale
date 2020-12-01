import myAxios from "./myAxios";

const projectAPI = {
  updateTask(taskId, data) {
    return myAxios.PATCH(`/task/${taskId}`, data);
  },
};

export default projectAPI;
