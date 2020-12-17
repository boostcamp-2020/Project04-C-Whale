const ProjectDto = require('@models/dto/project');
const PositionDto = require('@models/dto/position');
const projectService = require('@services/project');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { validator, getTypeError } = require('@utils/validator');
const ParamsValidator = require('@utils/params-validator');

const getProjects = asyncTryCatch(async (req, res) => {
  const projectInfos = await projectService.retrieveProjects(req.user.id);

  responseHandler(res, 200, { projectInfos });
});

const getProjectById = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  const project = await projectService.retrieveById({ ...req.params, userId });

  responseHandler(res, 200, { project });
});

const createProject = asyncTryCatch(async (req, res) => {
  try {
    await validator(ProjectDto, req.body, { groups: ['create'] });
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: creatorId } = req.user;
  const projectId = await projectService.create({ ...req.body, creatorId });

  responseHandler(res, 201, { message: 'ok', projectId });
});

const updateProject = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    if (req.method === 'PUT') {
      await validator(ProjectDto, req.body, { groups: ['put'] });
    } else {
      await validator(ProjectDto, req.body, { groups: ['patch'] });
    }
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  await projectService.update({ ...req.body, ...req.params, userId });

  responseHandler(res, 200, { message: 'ok' });
});

const deleteProject = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  await projectService.remove({ ...req.params, userId });

  responseHandler(res, 200, { message: 'ok' });
});

const updateSectionPositions = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(PositionDto, req.body);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  await projectService.updateSectionPositions({ ...req.body, ...req.params, userId });

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = {
  getProjects,
  getProjectById,
  createProject,
  updateProject,
  deleteProject,
  updateSectionPositions,
};
