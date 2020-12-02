const sequelize = require('@models');

const { models } = sequelize;
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
  await projectService.create(req.body);

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

const createSection = asyncTryCatch(async (req, res) => {
  await sequelize.transaction(async t => {
    const project = await models.project.findByPk(req.params.projectId);
    const section = await models.section.create(req.body, {
      transaction: t,
    });
    await section.setProject(project, {
      transaction: t,
    });
  });

  responseHandler(res, 201, {
    message: 'ok',
  });
});

const updateSectionTaskPositions = asyncTryCatch(async (req, res) => {
  const { orderedTasks } = req.body;

  await sequelize.transaction(async t => {
    await Promise.all(
      orderedTasks.map(async (taskId, position) => {
        await models.task.update(
          { position, parentId: null },
          { where: { id: taskId } },
          { transaction: t },
        );
      }),
    );
  });

  responseHandler(res, 200, {
    message: 'ok',
  });
});

const updateSection = asyncTryCatch(async (req, res) => {
  await models.section.update(req.body, {
    where: {
      id: req.params.sectionId,
    },
  });

  responseHandler(res, 200, {
    message: 'ok',
  });
});

const deleteSection = asyncTryCatch(async (req, res) => {
  await models.project.destroy({
    where: {
      id: req.params.sectionId,
    },
  });

  responseHandler(res, 200, {
    message: 'ok',
  });
});

module.exports = {
  getProjects,
  // getTodayProject,
  getProjectById,
  createProject,
  updateProject,
  deleteProject,
  createSection,
  updateSection,
  updateSectionTaskPositions,
  deleteSection,
};
