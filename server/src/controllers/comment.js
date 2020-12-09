const commentService = require('@services/comment');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');

const getComments = asyncTryCatch(async (req, res) => {
  const comments = await commentService.retrieveAllByTaskId(req.params.taskId);

  responseHandler(res, 200, comments);
});

const createComment = asyncTryCatch(async (req, res) => {
  await commentService.create(req.params.taskId, req.body);

  responseHandler(res, 201, { message: 'ok' });
});

const updateComment = asyncTryCatch(async (req, res) => {
  await commentService.update(req.params.commentId, req.body);

  responseHandler(res, 200, { message: 'ok' });
});

const deleteComment = asyncTryCatch(async (req, res) => {
  await commentService.remove(req.params.commentId);

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = { getComments, createComment, updateComment, deleteComment };
