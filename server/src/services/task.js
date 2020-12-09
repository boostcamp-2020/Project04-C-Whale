const sequelize = require('@models');
const { isTaskOwner } = require('@services/authorization-check');
const errorMessage = require('@utils/error-messages');
const errorCode = require('@utils/error-codes');

const { models } = sequelize;
const taskModel = models.task;

const retrieveById = async ({ id, userId }) => {
  const task = await taskModel.findByPk(id, {
    include: [
      'labels',
      'priority',
      'alarm',
      'bookmarks',
      {
        model: taskModel,
        include: ['labels', 'priority', 'alarm', 'bookmarks'],
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });
  if (!task) {
    const error = new Error(errorMessage.NOT_FOUND_ERROR('작업'));
    error.status = errorCode.NOT_FOUND_ERROR;
    throw error;
  }
  if (!(await isTaskOwner({ id, userId }))) {
    const error = new Error(errorMessage.FORBIDDEN_ERROR);
    error.status = errorCode.FORBIDDEN_ERROR;
    throw error;
  }
  return task;
};

const retrieveAll = async userId => {
  const task = await taskModel.findAll({
    where: { isDone: false },
    include: [
      'labels',
      'priority',
      'alarm',
      'bookmarks',
      {
        model: taskModel,
        include: ['labels', 'priority', 'alarm', 'bookmarks'],
      },
      {
        model: models.project,
        attributes: [],
        where: { creatorId: userId },
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });
  return task;
};

const create = async ({ projectId, sectionId, ...taskData }) => {
  const { labelIdList, dueDate, ...rest } = taskData;
  const result = await sequelize.transaction(async t => {
    const section = await models.section.findByPk(sectionId, { include: 'tasks' });

    const maxPosition = section.toJSON().tasks.reduce((max, task) => {
      return Math.max(max, task.position);
    }, 0);

    const task = await models.task.create(
      { projectId, sectionId, dueDate, position: maxPosition + 1, ...rest },
      { transaction: t },
    );
    if (labelIdList) {
      await task.setLabels(JSON.parse(labelIdList), { transaction: t });
    }

    return task;
  });

  return !!result;
};

const update = async taskData => {
  const { id, labelIdList, dueDate, ...rest } = taskData;
  const result = await sequelize.transaction(async t => {
    await taskModel.update(
      { dueDate, ...rest },
      {
        where: { id },
      },
      { transaction: t },
    );

    const task = await taskModel.findByPk(id, { transaction: t });
    if (labelIdList) {
      await task.setLabels(JSON.parse(labelIdList), { transaction: t });
    }
    return true;
  });

  return result;
};

const remove = async id => {
  const result = await taskModel.destroy({
    where: {
      id,
    },
  });

  return result;
};

module.exports = { retrieveById, retrieveAll, create, update, remove };
