const { errorHandler } = require('@utils/handler');

const NOT_FOUND_ERROR = 404;
const INTERNAL_ERROR = 500;

const lastErrorHandler = app => {
  app.use((req, res, next) => {
    const err = new Error('Not Found');
    err.status = NOT_FOUND_ERROR;
    next(err);
  });

  app.use((err, req, res) => {
    errorHandler(res, err.status || INTERNAL_ERROR, err.message);
  });
};

module.exports = lastErrorHandler;
