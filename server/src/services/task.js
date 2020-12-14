const sequelize = require('@models');
const { isTaskOwner, isProjectOwner, isSectionOwner } = require('@services/authorization-check');
const errorMessage = require('@utils/error-messages');
const errorCode = require('@utils/error-codes');

const { models } = sequelize;
const taskModel = models.task;

// const isValidTask = task => {
//   if (!task) {
//     const error = new Error(errorMessage.NOT_FOUND_ERROR('task'));
//     error.status = errorCode.NOT_FOUND_ERROR;
//     throw error;
//   }
// };

const retrieveById = async ({ id, userId }) => {
  const task = await taskModel.findByPk(id, {
    include: [
      'bookmarks',
      {
        model: taskModel,
        include: ['bookmarks'],
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });

  // task가 없는 경우, url params로 넘어오는 taskId가 유효하지 않음
  // isValidTask(task);
  if (!task) {
    const error = new Error(errorMessage.NOT_FOUND_ERROR('task'));
    error.status = errorCode.NOT_FOUND_ERROR;
    throw error;
  }

  // 요청받은 task가 해당 유저의 작업이 아닌 경우 리소스 접근 권한이 없음
  if (!(await isTaskOwner({ id, userId }))) {
    const error = new Error(errorMessage.FORBIDDEN_ERROR('task'));
    error.status = errorCode.FORBIDDEN_ERROR;
    throw error;
  }
  return task;
};

const retrieveAll = async userId => {
  const tasks = await taskModel.findAll({
    include: [
      'bookmarks',
      'comments',
      {
        model: taskModel,
        include: ['bookmarks', 'comments'],
        where: { isDone: false },
        required: false,
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
        required: false,
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });
  return tasks;
};

const create = async ({ projectId, sectionId, userId, ...taskData }) => {
  const { dueDate, ...rest } = taskData;

  const project = await models.project.findByPk(projectId);
  if (!project) {
    const error = new Error(errorMessage.NOT_FOUND_ERROR('project'));
    error.status = errorCode.NOT_FOUND_ERROR;
    throw error;
  }
  if (!(await isProjectOwner({ id: projectId, userId }))) {
    const error = new Error(errorMessage.FORBIDDEN_ERROR('project'));
    error.status = errorCode.FORBIDDEN_ERROR;
    throw error;
  }

  const result = await sequelize.transaction(async t => {
    const section = await models.section.findByPk(sectionId, { include: 'tasks' });
    if (!section) {
      const error = new Error(errorMessage.NOT_FOUND_ERROR('section'));
      error.status = errorCode.NOT_FOUND_ERROR;
      throw error;
    }
    if (!(await isSectionOwner({ id: sectionId, userId }))) {
      const error = new Error(errorMessage.FORBIDDEN_ERROR('section'));
      error.status = errorCode.FORBIDDEN_ERROR;
      throw error;
    }

    if (section.projectId !== projectId) {
      const error = new Error(errorMessage.WRONG_RELATION_ERROR('project, section'));
      error.status = errorCode.BAD_REQUEST_ERROR;
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
    try {
      const task = await taskModel.findByPk(id, { transaction: t });
      if (!task) {
        const error = new Error(errorMessage.NOT_FOUND_ERROR('task'));
        error.status = errorCode.NOT_FOUND_ERROR;
        throw error;
      }

      // 요청받은 task가 해당 유저의 작업이 아닌 경우 리소스 접근 권한이 없음
      if (!(await isTaskOwner({ id, userId }))) {
        const error = new Error(errorMessage.FORBIDDEN_ERROR('task'));
        error.status = errorCode.FORBIDDEN_ERROR;
        throw error;
      }

      await task.update({ dueDate, ...rest });

      task.save();
      return true;
    } catch (err) {
      t.rollback();
      throw err;
    }
  });

  return result;
};

const updateChildTaskPositions = async (parentId, orderedTasks) => {
  const result = await sequelize.transaction(async t => {
    return await Promise.all(
      orderedTasks.map(async (taskId, position) => {
        return await models.task.update(
          { position, parentId },
          { where: { id: taskId } },
          { transaction: t },
        );
      }),
    );
  });

  return (
    result.length === orderedTasks.length && result.every(countArray => countArray.length !== 0)
  );
};

const remove = async id => {
  const task = await taskModel.findByPk(id);
  if (!task) {
    const error = new Error(errorMessage.NOT_FOUND_ERROR('task'));
    error.status = errorCode.NOT_FOUND_ERROR;
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
