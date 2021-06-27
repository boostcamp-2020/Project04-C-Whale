import myAxios from "./myAxios";

const projectAPI = {
  getProjectById(projectId) {
    return myAxios.get(`/project/${projectId}`);
  },
  getProjects() {
    return myAxios.get("/project");
  },
  getTodayProject() {
    return myAxios.get("/project/today");
  },
  createProject(data) {
    return myAxios.post("/project", data);
  },
  updateProject(projectId, data) {
    return myAxios.patch(`/project/${projectId}`, data);
  },
  createSection(projectId, data) {
    return myAxios.post(`/project/${projectId}/section`, data);
  },
  updateSection(projectId, sectionId, data) {
    return myAxios.patch(`/project/${projectId}/section/${sectionId}`, data);
  },
  updateSectionPosition(projectId, data) {
    return myAxios.patch(`/project/${projectId}/section/position`, data);
  },
  updateTaskPosition(projectId, sectionId, data) {
    return myAxios.patch(`/project/${projectId}/section/${sectionId}/task/position`, data);
  },
  deleteProject(projectId) {
    return myAxios.delete(`/project/${projectId}`);
  },
};

export default projectAPI;
