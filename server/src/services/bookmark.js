const sequelize = require('@models');
const { isTaskOwner } = require('@services/authority-check');
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

// const create = async ({ userId, taskId, ...commentData }) => {
//   const task = await taskModel.findByPk(taskId);
//   if (!task) {
//     const error = customError.NOT_FOUND_ERROR('task');
//     throw error;
//   }
//   if (!(await isTaskOwner({ id: taskId, userId }))) {
//     const error = customError.FORBIDDEN_ERROR('task');
//     throw error;
//   }

//   const result = await commentModel.create({ ...commentData, taskId });

//   return result;
// };

// const remove = async ({ id, taskId, userId }) => {
//   const comment = await commentModel.findByPk(id);
//   if (!comment) {
//     const error = customError.NOT_FOUND_ERROR('comment');
//     throw error;
//   }
//   if (!(await isCommentOwner({ id, userId }))) {
//     const error = customError.FORBIDDEN_ERROR('comment');
//     throw error;
//   }
//   if (comment.taskId !== taskId) {
//     const error = customError.WRONG_RELATION_ERROR('task, comment');
//     throw error;
//   }
//   const result = await comment.destroy();
//   result.save();
//   return true;

// };

module.exports = { retrieveAllByTaskId };
