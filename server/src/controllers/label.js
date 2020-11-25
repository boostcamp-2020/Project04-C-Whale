const labelModel = require('@models').models.label;
const { responseHandler } = require('@utils/handler');

const getAllLabels = async (req, res, next) => {
  try {
    const labels = await labelModel.findAll({
      where: { userId: req.user.id },
      attributes: ['id', 'title', 'color'],
    });

    responseHandler(res, 200, { labels });
  } catch (err) {
    next(err);
  }
};

const createLabel = async (req, res, next) => {
  try {
    const { title, color } = req.body;
    const result = await labelModel.create({ title, color, userId: req.user.id });
    if (result) {
      responseHandler(res, 201);
    } else {
      throw Error('Internal Server Error');
    }
  } catch (err) {
    next(err);
  }
};

const updateLabel = async (req, res, next) => {
  const { labelId } = req.params;
  const { title, color } = req.body;

  try {
    const result = await labelModel.update({ title, color }, { where: { id: labelId } });
    if (result[0] !== 1) {
      throw Error('Internal Server Error');
    }
    responseHandler(res, 200);
  } catch (err) {
    next(err);
  }
};

const isValidRequestDatas = async (req, res, next) => {
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

const isOwnLabel = async (req, res, next) => {
  const { labelId } = req.params;
  const { id } = req.user;
  const error = new Error('Forbidden');
  error.status = 403;

  try {
    const label = await labelModel.findByPk(labelId, { attributes: ['userId'] });
    if (id !== label.userId) {
      throw error;
    }
    next();
  } catch (err) {
    next(err);
  }
};

const isValidLabelId = async (req, res, next) => {
  const { labelId } = req.params;
  const error = new Error('Not Found');
  error.status = 404;

  try {
    if (!labelId || labelId === '') {
      throw error;
    }
    const label = await labelModel.findByPk(labelId);

    if (!label) {
      throw error;
    }
    next();
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getAllLabels,
  createLabel,
  updateLabel,
  isValidRequestDatas,
  isOwnLabel,
  isValidLabelId,
};
