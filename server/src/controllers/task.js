const { responseHandler } = require('@utils/handler');
const sequelize = require('@models');
const { models } = require('@models');

const createTask = async (req, res, next) => {
  const t = await sequelize.transaction();

  try {
    const { labelIdList, dueDate, ...rest } = req.body;

    const newTask = await models.task.create({ dueDate, ...rest }, { transaction: t });
    await newTask.setLabels(JSON.parse(labelIdList), { transaction: t });
    await t.commit();

    responseHandler(res, 201, { message: 'ok', id: newTask.id });
  } catch (err) {
    await t.rollback();
    next(err);
  }
};

module.exports = { createTask };
