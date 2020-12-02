const sequelize = require('@models');

const { models } = sequelize;
const taskModel = models.task;

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

const retrieveAll = async userId => {
  // const tasks = await taskModel.findAll({
  //   attributes: ['id', 'title'],
  //   include: {
  //     model: models.project,
  //     attributes: [],
  //     where: { creatorId: userId },
  //   },
  //   // order: [['title', 'ASC']],
  // });

  const task = await taskModel.findAll({
    include: [
      'labels',
      'priority',
      'alarm',
      'bookmarks',
      {
        model: taskModel,
        include: ['labels', 'priority', 'alarm', 'bookmarks'],
      },
      {
        model: models.project,
        attributes: [],
        where: { creatorId: userId },
      },
    ],
    order: [[taskModel, 'position', 'ASC']],
  });
  return task;
};

const create = async ({ projectId, sectionId, ...taskData }) => {
  const { labelIdList, dueDate, ...rest } = taskData;
  const result = await sequelize.transaction(async t => {
    const section = await models.section.findByPk(sectionId, { include: 'tasks' });

    const maxPosition = section.toJSON().tasks.reduce((max, task) => {
      return Math.max(max, task.position);
    }, 0);

    const task = await models.task.create(
      { projectId, sectionId, dueDate, position: maxPosition + 1, ...rest },
      { transaction: t },
    );
    if (labelIdList) {
      await task.setLabels(JSON.parse(labelIdList), { transaction: t });
    }

    return task;
  });

  return !!result;
};

const update = async taskData => {
  const { id, labelIdList, dueDate, ...rest } = taskData;
  const result = await sequelize.transaction(async t => {
    await taskModel.update(
      { dueDate, ...rest },
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

module.exports = { retrieveById, retrieveAll, create, update, remove };
