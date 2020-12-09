/* eslint-disable no-return-await */
const sequelize = require('@models');

const { models } = sequelize;
const sectionModel = models.section;

const create = async ({ projectId, ...data }) => {
  const result = await sequelize.transaction(async t => {
    const project = await models.project.findByPk(projectId, {
      include: sectionModel,
    });

    const maxPosition = project.toJSON().sections.reduce((max, section) => {
      return Math.max(max, section.position);
    }, 0);

    const section = await sectionModel.create(
      { ...data, position: maxPosition + 1 },
      { transaction: t },
    );
    await section.setProject(project, {
      transaction: t,
    });
    return section;
  });

  return !!result;
};

const update = async ({ id, ...data }) => {
  const [result] = await models.section.update(data, { where: { id } });

  return result !== 0;
};

const updateTaskPositions = async orderedTasks => {
  const result = await sequelize.transaction(async t => {
    return await Promise.all(
      orderedTasks.map(async (taskId, position) => {
        return await models.task.update(
          { position, parentId: null },
          { where: { id: taskId } },
          { transaction: t },
        );
      }),
    );
  });

  return (
    result.length === orderedTasks.length && result.every(countArray => countArray.length !== 0)
  );
};

const remove = async id => {
  const result = await sectionModel.destroy({ where: { id } });

  return result === 1;
};
module.exports = { create, update, updateTaskPositions, remove };
