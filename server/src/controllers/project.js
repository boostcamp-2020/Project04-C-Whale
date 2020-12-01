const sequelize = require('@models');
const { Op } = require('sequelize');

const { models } = sequelize;
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');
const getTodayStartEnd = require('@utils/today-start-end');

const getProjects = asyncTryCatch(async (req, res) => {
  const projects = await models.project.findAll({
    attributes: ['id', 'title', [sequelize.fn('COUNT', sequelize.col('tasks.id')), 'taskCount']],
    include: {
      model: models.task,
      attributes: [],
    },
    group: ['project.id'],
  });

  const { todayStart, todayEnd } = getTodayStartEnd();

  const todayProject = {
    title: '오늘',
  };
  todayProject.taskCount = await models.task.count({
    where: {
      dueDate: {
        [Op.and]: {
          [Op.gt]: todayStart,
          [Op.lt]: todayEnd,
        },
      },
    },
  });
  projects.push(todayProject);

  responseHandler(res, 201, projects);
});

const getProjectById = asyncTryCatch(async (req, res) => {
  const project = await models.project.findByPk(req.params.projectId, {
    attributes: ['id', 'title', 'isList'],
    include: {
      model: models.section,
      include: {
        model: models.task,
        where: { isDone: false, parentId: null },
        include: ['priority', 'labels', 'alarm', 'tasks'],
        required: false,
      },
    },
    order: [
      [models.section, 'position', 'ASC'],
      [models.section, models.task, 'position', 'ASC'],
      [models.section, models.task, models.task, 'position', 'ASC'],
    ],
  });

  responseHandler(res, 201, project);
});

const createProject = asyncTryCatch(async (req, res) => {
  await sequelize.transaction(async t => {
    const project = await models.project.create(req.body, {
      transaction: t,
    });
    const section = await models.section.create(
      {},
      {
        transaction: t,
      },
    );
    await section.setProject(project, {
      transaction: t,
    });
  });

  responseHandler(res, 201, {
    message: 'ok',
  });
});

const updateProject = asyncTryCatch(async (req, res) => {
  await models.project.update(req.body, {
    where: {
      id: req.params.projectId,
    },
  });
  responseHandler(res, 201, {
    message: 'ok',
  });
});

const deleteProject = asyncTryCatch(async (req, res) => {
  await models.project.destroy({
    where: {
      id: req.params.projectId,
    },
  });
  responseHandler(res, 201, {
    message: 'ok',
  });
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

  responseHandler(res, 201, {
    message: 'ok',
  });
});

const updateSection = asyncTryCatch(async (req, res) => {
  await models.section.update(req.body, {
    where: {
      id: req.params.sectionId,
    },
  });

  responseHandler(res, 201, {
    message: 'ok',
  });
});

const deleteSection = asyncTryCatch(async (req, res) => {
  await models.project.destroy({
    where: {
      id: req.params.sectionId,
    },
  });

  responseHandler(res, 201, {
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
