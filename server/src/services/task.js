const taskModel = require('@models').models.task;
const sequelize = require('@models');

const retrieveById = async id => {
  const task = await taskModel.findByPk(id, {
    include: [
      'labels',
      'priority',
      'alarm',
      'bookmarks',
      {
        model: taskModel,
        include: ['labels', 'priority', 'alarm', 'bookmarks'],
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });
  return task;
};

const create = async (labelIdList, dueDate, taskData) => {
  const result = await sequelize.transaction(async t => {
    const task = await taskModel.create({ dueDate, ...taskData }, { transaction: t });
    await task.setLabels(JSON.parse(labelIdList), { transaction: t });

    return task;
  });

  return !!result;
};

const update = async (labelIdList, dueDate, id, taskData) => {
  const result = await sequelize.transaction(async t => {
    await taskModel.update(
      { dueDate, ...taskData },
      {
        where: { id },
      },
      { transaction: t },
    );

    const task = await taskModel.findByPk(id, { transaction: t });
    if (labelIdList) {
      await task.setLabels(JSON.parse(labelIdList), { transaction: t });
    }
    return true;
  });

  return result;
};

const remove = async id => {
  const result = await taskModel.destroy({
    where: {
      id,
    },
  });

  return result;
};

module.exports = { retrieveById, create, update, remove };
