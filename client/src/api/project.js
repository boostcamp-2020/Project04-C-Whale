import myAxios from "./myAxios";

const projectAPI = {
  getProjectById(projectId) {
    return myAxios.GET(`/project/${projectId}`);
  },
  getProjects() {
    return myAxios.GET("/project");
  },
  updateProject(projectId, data) {
    return myAxios.PATCH(`/project/${projectId}`, data);
  },
  updateSection(projectId, sectionId, data) {
    return myAxios.PUT(`/project/${projectId}/section/${sectionId}`, data);
  },
};

export default projectAPI;