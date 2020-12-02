import myAxios from "./myAxios";

const projectAPI = {
  getProjectById(projectId) {
    return myAxios.GET(`/project/${projectId}`);
  },
  getProjects() {
    return myAxios.GET("/project");
  },
};

export default projectAPI;
