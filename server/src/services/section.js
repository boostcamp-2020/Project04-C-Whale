/* eslint-disable no-return-await */
const sequelize = require('@models');
const { customError } = require('@utils/custom-error');

const { models } = sequelize;
const sectionModel = models.section;

const create = async ({ projectId, userId, ...data }) => {
  await sequelize.transaction(async t => {
    const project = await models.project.findByPk(projectId, {
      include: sectionModel,
    });

    if (!project) {
      throw customError.NOT_FOUND_ERROR('project');
    }

    if (project.creatorId !== userId) {
      throw customError.FORBIDDEN_ERROR();
    }

    const maxPosition = project.sections.reduce((max, section) => {
      return Math.max(max, section.position);
    }, 0);

    const section = await sectionModel.create(
      { ...data, position: maxPosition + 1 },
      { transaction: t },
    );
    await section.setProject(project, {
      transaction: t,
    });
  });

  return true;
};

const update = async ({ projectId, sectionId, userId, ...data }) => {
  const [result] = await models.section.update(data, { where: { id: sectionId } });

  return result !== 0;
};

const updateTaskPositions = async ({ projectId, sectionId, userId, ...data }) => {
  const { orderedTasks } = data;

  const project = await models.project.findByPk(projectId);
  if (!project) {
    throw customError.NOT_FOUND_ERROR('project');
  }
  if (project.creatorId !== userId) {
    throw customError.FORBIDDEN_ERROR();
  }
  const [section] = await project.getSections({ where: { id: sectionId } });
  if (!section) {
    throw customError.NOT_FOUND_ERROR('section');
  }

  const tasks = await section.getTasks();
  if (!tasks.every(task => orderedTasks.find(orderedTask => orderedTask === task.id))) {
    throw customError.WRONG_RELATION_ERROR(['please check projectId, sectionId, tasks Id']);
  }

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

const remove = async ({ projectId, sectionId, userId }) => {
  const result = await sectionModel.destroy({ where: { id: sectionId } });

  return result === 1;
};
module.exports = { create, update, updateTaskPositions, remove };
