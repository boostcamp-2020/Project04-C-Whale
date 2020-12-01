const { models } = require('@models');
const taskService = require('@services/task');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');
const { isValidDueDate } = require('@utils/date');

const getTaskById = asyncTryCatch(async (req, res) => {
  const task = await taskService.retrieveById(req.params.taskId);

  responseHandler(res, 200, task);
});

const createTask = asyncTryCatch(async (req, res) => {
  const { labelIdList, dueDate, ...rest } = req.body;

  // TODO middle ware로 빼내는게 좋을 것 같음
  if (!isValidDueDate(dueDate)) {
    const err = new Error('유효하지 않은 dueDate');
    err.status = 400;
    throw err;
  }

  await taskService.create(labelIdList, dueDate, rest);
  responseHandler(res, 201, { message: 'ok' });
});

const updateTask = asyncTryCatch(async (req, res) => {
  const { labelIdList, dueDate, ...rest } = req.body;

  if (!isValidDueDate(dueDate)) {
    const err = new Error('유효하지 않은 dueDate');
    err.status = 400;
    throw err;
  }

  const { taskId } = req.params;

  await taskService.update(labelIdList, dueDate, taskId, rest);
  responseHandler(res, 200, { message: 'ok' });
});

const deleteTask = asyncTryCatch(async (req, res) => {
  await taskService.remove(req.params.taskId);
  responseHandler(res, 200, { message: 'ok' });
});

const getComments = asyncTryCatch(async (req, res) => {
  const task = await models.task.findByPk(req.params.taskId);
  const comments = await task.getComments();

  responseHandler(res, 200, comments);
});

const createComment = asyncTryCatch(async (req, res) => {
  const { taskId } = req.params;
  await models.comment.create({ ...req.body, taskId });

  responseHandler(res, 201, {
    message: 'ok',
  });
});

const updateComment = asyncTryCatch(async (req, res) => {
  await models.comment.update(req.body, {
    where: {
      id: req.params.commentId,
    },
  });

  responseHandler(res, 200, {
    message: 'ok',
  });
});

const deleteComment = asyncTryCatch(async (req, res) => {
  await models.comment.destroy({
    where: {
      id: req.params.commentId,
    },
  });

  responseHandler(res, 200, {
    message: 'ok',
  });
});

module.exports = {
  getTaskById,
  createTask,
  updateTask,
  deleteTask,
  getComments,
  createComment,
  updateComment,
  deleteComment,
};
