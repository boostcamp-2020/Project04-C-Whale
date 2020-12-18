/* eslint-disable no-return-await */
const sequelize = require('@models');
const { isTaskOwner, isProjectOwner } = require('@services/authority-check');
const { customError } = require('@utils/custom-error');

const { models } = sequelize;
const taskModel = models.task;

const retrieveById = async ({ id, userId }) => {
  const task = await taskModel.findByPk(id, {
    include: [
      'tasks',
      {
        model: models.section,
        attribute: [],
        include: [
          {
            model: models.project,
            attributes: ['creatorId', 'title', 'id'],
          },
        ],
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });

  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  if (!(await isTaskOwner({ id, userId }))) {
    const error = customError.FORBIDDEN_ERROR();
    throw error;
  }
  return task;
};

const retrieveAll = async userId => {
  const tasks = await taskModel.findAll({
    include: [
      {
        model: taskModel,
        include: ['bookmarks', 'comments'],
        required: false,
      },
      {
        model: models.bookmark,
        required: false,
        order: [['createdAt', 'ASC']],
      },
      {
        model: models.comment,
        required: false,
        order: [['createdAt', 'ASC']],
      },
      {
        model: models.section,
        attribute: ['id', 'title', 'projectId', 'position'],
        include: [
          {
            model: models.project,
            attributes: ['creatorId', 'title', 'color'],
            where: { creatorId: userId },
          },
        ],
      },
    ],
    where: { parentId: null },
    having: { 'section.project.creatorId': userId },
    order: [[taskModel, 'position', 'ASC']],
  });

  return tasks;
};

const create = async ({ projectId, sectionId, userId, ...taskData }) => {
  const { dueDate, ...rest } = taskData;

  const project = await models.project.findByPk(projectId);
  if (!project) {
    const error = customError.NOT_FOUND_ERROR('project');
    throw error;
  }
  if (!(await isProjectOwner({ id: projectId, userId }))) {
    const error = customError.FORBIDDEN_ERROR('');
    throw error;
  }

  const result = await sequelize.transaction(async t => {
    const [section] = await project.getSections({ include: 'tasks', where: { id: sectionId } });
    if (!section) {
      const error = customError.NOT_FOUND_ERROR('section');
      throw error;
    }

    const maxPosition = section.toJSON().tasks.reduce((max, task) => {
      return Math.max(max, task.position);
    }, 0);

    const task = await models.task.create(
      { sectionId, dueDate, position: maxPosition + 1, ...rest },
      { transaction: t },
    );

    return task;
  });

  return !!result;
};

const update = async taskData => {
  const { id, dueDate, userId, ...rest } = taskData;

  const result = await sequelize.transaction(async t => {
    const task = await taskModel.findByPk(id);
    if (!task) {
      throw customError.NOT_FOUND_ERROR('task');
    }

    if (!(await isTaskOwner({ id, userId }))) {
      throw customError.FORBIDDEN_ERROR();
    }

    await task.update({ dueDate, ...rest }, { transaction: t });

    return true;
  });

  return result;
};

const updateChildTaskPositions = async ({ parentId, userId, ...rest }) => {
  const { orderedTasks } = rest;
  const task = await taskModel.findByPk(parentId);

  if (!task) {
    throw customError.NOT_FOUND_ERROR('task');
  }
  if (!(await isTaskOwner({ id: parentId, userId }))) {
    throw customError.FORBIDDEN_ERROR();
  }

  await sequelize.transaction(async t => {
    return await Promise.all(
      orderedTasks.map(async (taskId, position) => {
        return await taskModel.update(
          { position, parentId },
          { where: { id: taskId } },
          { transaction: t },
        );
      }),
    );
  });

  return true;
};

const remove = async id => {
  const task = await taskModel.findByPk(id);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  const result = await taskModel.destroy({
    where: {
      id,
    },
  });

  return result;
};

module.exports = {
  retrieveById,
  retrieveAll,
  create,
  update,
  remove,
  updateChildTaskPositions,
};
