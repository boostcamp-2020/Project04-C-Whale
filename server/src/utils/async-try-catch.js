const asyncTryCatch = fn => {
  return async (req, res, next) => {
    try {
      await fn(req, res, next);
    } catch (e) {
      console.error(e);
      next(e);
    }
  };
};

module.exports = { asyncTryCatch };
