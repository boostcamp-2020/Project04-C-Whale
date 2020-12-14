const sequelize = require('@models');
const { isTaskOwner, isCommentOwner } = require('@services/authority-check');
const { customError } = require('@utils/custom-error');

const { models } = sequelize;
const taskModel = models.task;
const commentModel = models.comment;

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

const create = async ({ userId, taskId, ...commentData }) => {
  const task = await taskModel.findByPk(taskId);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  if (!(await isTaskOwner({ id: taskId, userId }))) {
    const error = customError.FORBIDDEN_ERROR('task');
    throw error;
  }

  const result = await commentModel.create({ ...commentData, taskId });

  return result;
};

const update = async ({ id, taskId, userId, ...data }) => {
  const task = await taskModel.findByPk(taskId);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  if (!(await isTaskOwner({ id: taskId, userId }))) {
    const error = customError.FORBIDDEN_ERROR('task');
    throw error;
  }

  const comment = await commentModel.findByPk(id);

  if (!comment) {
    const error = customError.NOT_FOUND_ERROR('comment');
    throw error;
  }

  if (!(await isCommentOwner({ id, userId }))) {
    const error = customError.FORBIDDEN_ERROR('comment');
    throw error;
  }

  if (comment.taskId !== taskId) {
    const error = customError.WRONG_RELATION_ERROR('task, comment');
    throw error;
  }

  comment.update({ ...data });
  comment.save();

  return true;
};

const remove = async ({ id, taskId, userId }) => {
  const comment = await commentModel.findByPk(id);

  if (!comment) {
    const error = customError.NOT_FOUND_ERROR('comment');
    throw error;
  }
  if (!(await isCommentOwner({ id, userId }))) {
    const error = customError.FORBIDDEN_ERROR('comment');
    throw error;
  }

  if (comment.taskId !== taskId) {
    const error = customError.WRONG_RELATION_ERROR('task, comment');
    throw error;
  }

  const result = await comment.destroy();
  result.save();

  return true;
};

module.exports = { retrieveAllByTaskId, create, update, remove };
