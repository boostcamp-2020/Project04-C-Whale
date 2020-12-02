const projectService = require('@services/project');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');

const getProjects = asyncTryCatch(async (req, res) => {
  const projects = await projectService.retrieveProjects();

  responseHandler(res, 200, projects);
});

const getProjectById = asyncTryCatch(async (req, res) => {
  const project = await projectService.retrieveById(req.params.projectId);

  responseHandler(res, 200, project);
});

const createProject = asyncTryCatch(async (req, res) => {
  const { id: creatorId } = req.user;
  await projectService.create({ creatorId, ...req.body });

  responseHandler(res, 201, { message: 'ok' });
});

const updateProject = asyncTryCatch(async (req, res) => {
  await projectService.update({ projectId: req.params.projectId, ...req.body });

  responseHandler(res, 200, { message: 'ok' });
});

const deleteProject = asyncTryCatch(async (req, res) => {
  await projectService.remove(req.params.projectId);

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = {
  getProjects,
  // getTodayProject,
  getProjectById,
  createProject,
  updateProject,
  deleteProject,
};
