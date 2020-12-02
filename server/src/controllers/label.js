const labelService = require('@services/label');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');

const getAllLabels = asyncTryCatch(async (req, res) => {
  const labels = await labelService.retrieveAll(req.user.id);

  responseHandler(res, 200, { labels });
});

const createLabel = asyncTryCatch(async (req, res) => {
  const isCreated = await labelService.create({ userId: req.user.id, ...req.body });

  if (!isCreated) {
    throw Error('Internal Server Error');
  }
  responseHandler(res, 201);
});

const updateLabel = asyncTryCatch(async (req, res) => {
  const isUpdated = await labelService.update({ id: req.params.labelId, ...req.body });

  if (!isUpdated) {
    throw Error('Internal Server Error');
  }
  responseHandler(res, 200);
});

const removeLabel = asyncTryCatch(async (req, res) => {
  const result = await labelService.remove(req.params.labelId);

  if (!result) {
    throw Error('Internal Server Error');
  }
  responseHandler(res, 200);
});

const isValidRequestDatas = (req, res, next) => {
  const error = new Error('Bad Request');
  error.status = 400;
  const { title, color } = req.body;
  try {
    if (!title || typeof title !== 'string' || title === '') {
      throw error;
    }
    if (!color || typeof color !== 'string' || color === '') {
      throw error;
    }
    next();
  } catch (err) {
    next(err);
  }
};

const isOwnLabel = asyncTryCatch(async (req, res, next) => {
  const { labelId } = req.params;
  const { id } = req.user;

  const label = await labelService.retrieveById(labelId);
  if (id !== label.userId) {
    const error = new Error('Forbidden');
    error.status = 403;
    throw error;
  }
  next();
});

const isValidLabelId = asyncTryCatch(async (req, res, next) => {
  const { labelId } = req.params;
  const error = new Error('Not Found');
  error.status = 404;

  if (!labelId || labelId === '') {
    throw error;
  }
  const label = await labelService.retrieveById(labelId);
  if (!label) {
    throw error;
  }
  next();
});

module.exports = {
  getAllLabels,
  createLabel,
  updateLabel,
  removeLabel,
  isValidRequestDatas,
  isOwnLabel,
  isValidLabelId,
};
