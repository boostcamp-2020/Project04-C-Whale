const { models } = require('@models');

const isTaskOwner = async ({ id, userId }) => {
  const { project } = await models.task.findByPk(id, {
    include: [
      {
        model: models.project,
        attributes: ['creatorId'],
      },
    ],
  });

  return project.creatorId === userId;
};

const isProjectOwner = async ({ id, userId }) => {
  const { creatorId } = await models.project.findByPk(id);
  return creatorId === userId;
};

const isSectionOwner = async ({ id, userId }) => {
  const { project } = await models.section.findByPk(id, {
    include: [
      {
        model: models.project,
        attributes: ['creatorId'],
      },
    ],
  });
  return project.creatorId === userId;
};

module.exports = { isTaskOwner, isProjectOwner, isSectionOwner };
