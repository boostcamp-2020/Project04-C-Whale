const sequelize = require('@models');
const { models } = require('@models');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');
const { isValidDueDate } = require('@utils/date');

const createTask = asyncTryCatch(async (req, res) => {
  const { labelIdList, dueDate, ...rest } = req.body;

  if (!isValidDueDate(dueDate)) {
    const err = new Error('유효하지 않은 dueDate');
    err.status = 400;
    throw err;
  }

  await sequelize.transaction(async t => {
    const newTask = await models.task.create({ dueDate, ...rest }, { transaction: t });
    await newTask.setLabels(JSON.parse(labelIdList), { transaction: t });
  });

  responseHandler(res, 201, { message: 'ok' });
});

module.exports = { createTask };
