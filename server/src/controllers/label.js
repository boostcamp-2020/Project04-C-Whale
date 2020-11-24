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

module.exports = { getAllLabels };
