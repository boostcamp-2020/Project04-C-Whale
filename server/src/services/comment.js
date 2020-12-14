const taskModel = require('@models').models.task;
const commentModel = require('@models').models.comment;
const { isTaskOwner } = require('@services/authority-check');
const { customError } = require('@utils/custom-error');

const retrieveAllByTaskId = async ({ userId, taskId }) => {
  const task = await taskModel.findByPk(taskId);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  if (!(await isTaskOwner({ id: taskId, userId }))) {
    const error = customError.FORBIDDEN_ERROR('task');
    throw error;
  }
  const comments = await task.getComments({ order: [['createdAt', 'ASC']] });
  return comments;
};

const create = async (taskId, commentData) => {
  const task = await taskModel.findByPk(taskId);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  const result = await commentModel.create({ ...commentData, taskId });

  return result;
};

const update = async (id, data) => {
  const result = await commentModel.update(data, { where: { id } });

  return result;
};

const remove = async id => {
  const result = await commentModel.destroy({
    where: { id },
  });
  return result;
};

module.exports = { retrieveAllByTaskId, create, update, remove };
