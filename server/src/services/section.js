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
  await section.update(data, { where: { id: sectionId } });
  section.save();

  return true;
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

  section.destroy();
  section.save();

  return true;
};
module.exports = { create, update, updateTaskPositions, remove };
