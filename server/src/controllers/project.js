const ProjectDto = require('@models/dto/project');
const projectService = require('@services/project');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { validator, getErrorMsg } = require('@utils/validator');

const getProjects = asyncTryCatch(async (req, res) => {
  const projectInfos = await projectService.retrieveProjects();

  responseHandler(res, 200, { projectInfos });
});

const getTodayProject = asyncTryCatch(async (req, res) => {
  const todayProject = await projectService.retrieveTodayProject();

  responseHandler(res, 200, todayProject);
});

const getProjectById = asyncTryCatch(async (req, res) => {
  const project = await projectService.retrieveById(req.params.projectId);

  responseHandler(res, 200, { project });
});

const createProject = asyncTryCatch(async (req, res) => {
  const { id: creatorId } = req.user;

  try {
    await validator(ProjectDto, req.body, { groups: ['create'] });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  const projectId = await projectService.create({ creatorId, ...req.body });

  responseHandler(res, 201, { message: 'ok', projectId });
});

const updateProject = asyncTryCatch(async (req, res) => {
  try {
    await validator(ProjectDto, { id: req.params.projectId, ...req.body });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  await projectService.update({ id: req.params.projectId, ...req.body });

  responseHandler(res, 200, { message: 'ok' });
});

const deleteProject = asyncTryCatch(async (req, res) => {
  try {
    await validator(ProjectDto, { id: req.params.projectId });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  await projectService.remove({ id: req.params.projectId });

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = {
  getProjects,
  getTodayProject,
  getProjectById,
  createProject,
  updateProject,
  deleteProject,
};
