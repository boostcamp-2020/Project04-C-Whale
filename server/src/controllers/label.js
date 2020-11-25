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
      responseHandler(res, 200);
    } else {
      throw Error('Internal Server Error');
    }
  } catch (err) {
    next(err);
  }
};

const isValidPostDatas = async (req, res, next) => {
  const error = new Error('Bad Request');
  error.status = 400;
  try {
    const { title, color } = req.body;
    if (!title && (typeof title !== 'string' || title === '')) {
      throw error;
    }
    if (!color && (typeof color !== 'string' || color === '')) {
      throw error;
    }
    next();
  } catch (err) {
    next(err);
  }
};

module.exports = { getAllLabels, createLabel, isValidPostDatas };
