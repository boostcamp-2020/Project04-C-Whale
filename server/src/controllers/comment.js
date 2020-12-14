const CommentDto = require('@models/dto/comment');
const commentService = require('@services/comment');
const { validator, getTypeError } = require('@utils/validator');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');
const ParamsValidator = require('@utils/params-validator');

const getComments = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }
  const comments = await commentService.retrieveAllByTaskId(req.params.taskId);

  responseHandler(res, 200, { comments });
});

const createComment = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(CommentDto, req.body, { groups: ['create'] });
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  await commentService.create(req.params.taskId, req.body);

  responseHandler(res, 201, { message: 'ok' });
});

const updateComment = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(CommentDto, req.body, { groups: ['update'] });
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  await commentService.update(req.params.commentId, req.body);

  responseHandler(res, 200, { message: 'ok' });
});

const deleteComment = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }
  await commentService.remove(req.params.commentId);

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = { getComments, createComment, updateComment, deleteComment };
