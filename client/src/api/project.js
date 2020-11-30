import myAxios from "./myAxios";

const projectAPI = {
  getProjectById(projectId) {
    return myAxios.GET(`/project/${projectId}`);
  },
};

export default projectAPI;
