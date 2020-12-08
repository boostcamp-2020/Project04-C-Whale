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
  createSection(projectId, data) {
    return myAxios.post(`/project/${projectId}/section`, data);
  },
  updateProject(projectId, data) {
    return myAxios.patch(`/project/${projectId}`, data);
  },
  updateSection(projectId, sectionId, data) {
    return myAxios.put(`/project/${projectId}/section/${sectionId}`, data);
  },
  updateTaskPosition(projectId, sectionId, data) {
    return myAxios.patch(`/project/${projectId}/section/${sectionId}/position`, data);
  },
};

export default projectAPI;
