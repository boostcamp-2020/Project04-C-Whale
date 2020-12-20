const { errorHandler } = require('@utils/handler');
const { customError } = require('@utils/custom-error');

const NOT_FOUND_ERROR = 404;

const lastErrorHandler = app => {
  app.use((req, res, next) => {
    const err = new Error('Not Found');
    err.status = NOT_FOUND_ERROR;
    next(err);
  });

  app.use((err, req, res, next) => {
    if (err.status) {
      errorHandler(res, err);
    } else {
      const internalServerError = customError.INTERNAL_SERVER_ERROR();
      errorHandler(res, internalServerError);
    }
  });
};

module.exports = lastErrorHandler;
