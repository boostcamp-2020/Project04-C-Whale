const sequelize = require('@models');
const { Op } = require('sequelize');

const { models } = sequelize;
const { responseHandler, errorHandler } = require('@utils/handler');
const getTodayStartEnd = require('@utils/today-start-end');

const getProjects = async (req, res) => {
  try {
    const projects = await models.project.findAll({
      attributes: ['id', 'title', [sequelize.fn('COUNT', sequelize.col('tasks.id')), 'taskCount']],
      include: {
        model: models.task,
        attributes: [],
      },
      group: ['project.id'],
    });

    const { todayStart, todayEnd } = getTodayStartEnd();

    const todayProject = { title: '오늘' };
    todayProject.taskCount = await await models.task.count({
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
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const getProjectById = async (req, res) => {
  try {
    const project = await models.project.findByPk(req.params.projectId, {
      attributes: ['id', 'title', 'isList'],
      include: {
        model: models.section,
        include: {
          model: models.task,
          include: {
            model: models.task,
            attributes: { exclude: ['createdAt', 'updatedAt'] },
          },
        },
      },
    });

    responseHandler(res, 201, project);
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const createProject = async (req, res) => {
  try {
    await sequelize.transaction(async t => {
      const project = await models.project.create(req.body, { transaction: t });
      const section = await models.section.create({}, { transaction: t });
      await section.setProject(project, { transaction: t });
    });

    responseHandler(res, 201, {
      message: 'ok',
    });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const updateProject = async (req, res) => {
  try {
    await models.project.update(req.body, {
      where: {
        id: req.params.projectId,
      },
    });
    responseHandler(res, 201, {
      message: 'ok',
    });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const deleteProject = async (req, res) => {
  try {
    await models.project.destroy({
      where: {
        id: req.params.projectId,
      },
    });
    responseHandler(res, 201, {
      message: 'ok',
    });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const createSection = async (req, res) => {
  try {
    const project = await models.project.findByPk(req.params.projectId);

    await sequelize.transaction(async t => {
      const section = await models.section.create(req.body, { transaction: t });
      await section.setProject(project, { transaction: t });
    });

    responseHandler(res, 201, {
      message: 'ok',
    });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const updateSection = async (req, res) => {
  try {
    await models.section.update(req.body, {
      where: {
        id: req.params.sectionId,
      },
    });

    responseHandler(res, 201, {
      message: 'ok',
    });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

const deleteSection = async (req, res) => {
  try {
    await models.project.destroy({
      where: {
        id: req.params.sectionId,
      },
    });

    responseHandler(res, 201, {
      message: 'ok',
    });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

module.exports = {
  getProjects,
  getProjectById,
  createProject,
  updateProject,
  deleteProject,
  createSection,
  updateSection,
  deleteSection,
};
