const BookmarkDto = require('@models/dto/bookmark');
const bookmarkService = require('@services/bookmark');
const { validator, getTypeError } = require('@utils/validator');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');
const ParamsValidator = require('@utils/params-validator');

const getBookmarks = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }
  const bookmarks = await bookmarkService.retrieveAllByTaskId({
    taskId: req.params.taskId,
    userId: req.user.id,
  });

  responseHandler(res, 200, { bookmarks });
});

const createBookmark = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(BookmarkDto, req.body);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { taskId } = req.params;
  const userId = req.user.id;
  await bookmarkService.create({ userId, taskId, ...req.body });

  responseHandler(res, 201, { message: 'ok' });
});

// const deleteComment = asyncTryCatch(async (req, res) => {
//   try {
//     await validator(ParamsValidator, req.params);
//   } catch (errs) {
//     const validationError = getTypeError(errs);
//     throw validationError;
//   }

//   const { commentId, taskId } = req.params;
//   const userId = req.user.id;
//   await commentService.remove({ id: commentId, taskId, userId });

//   responseHandler(res, 200, { message: 'ok' });
// });

module.exports = { getBookmarks, createBookmark };
