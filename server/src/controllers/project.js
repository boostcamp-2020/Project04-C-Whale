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

module.exports = { getProjects };
