const errorHandler = (res, error) => {
  res.status(error.status).json({
    message: error.message,
    code: error.code,
  });
};

const responseHandler = (res, code, result = { message: 'ok' }) => {
  res.status(code).json(result);
};

module.exports = { errorHandler, responseHandler };
