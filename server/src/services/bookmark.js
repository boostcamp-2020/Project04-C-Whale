const sequelize = require('@models');
const { isTaskOwner, isBookmarkOwner } = require('@services/authority-check');
const { customError } = require('@utils/custom-error');

const { models } = sequelize;
const bookmarkModel = models.bookmark;
const taskModel = models.task;

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
  const bookmarks = await task.getBookmarks({ order: [['createdAt', 'ASC']] });
  return bookmarks;
};

const create = async ({ userId, taskId, ...bookmarkData }) => {
  const task = await taskModel.findByPk(taskId);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  if (!(await isTaskOwner({ id: taskId, userId }))) {
    const error = customError.FORBIDDEN_ERROR('task');
    throw error;
  }

  const result = await bookmarkModel.create({ ...bookmarkData, taskId });

  return result;
};

const remove = async ({ id, taskId, userId }) => {
  const task = await taskModel.findByPk(taskId);
  if (!task) {
    const error = customError.NOT_FOUND_ERROR('task');
    throw error;
  }
  if (!(await isTaskOwner({ id: taskId, userId }))) {
    const error = customError.FORBIDDEN_ERROR('task');
    throw error;
  }

  const bookmark = await bookmarkModel.findByPk(id);

  if (!bookmark) {
    const error = customError.NOT_FOUND_ERROR('bookmark');
    throw error;
  }
  if (!(await isBookmarkOwner({ id, userId }))) {
    const error = customError.FORBIDDEN_ERROR('bookmark');
    throw error;
  }

  if (bookmark.taskId !== taskId) {
    const error = customError.WRONG_RELATION_ERROR('task, bookmark');
    throw error;
  }

  bookmark.destroy();
  bookmark.save();

  return true;
};

module.exports = { retrieveAllByTaskId, create, remove };
