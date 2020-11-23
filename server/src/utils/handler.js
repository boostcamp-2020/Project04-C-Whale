const errorHandler = (res, code, message = '') => {
  res.status(code).json({
    message,
  });
};

const responseHandler = (res, code, result = { message: 'ok' }) => {
  res.status(code).json({
    ...result,
  });
};

module.exports = { errorHandler, responseHandler };
