const { models } = require('@models');

const isTaskOwner = async ({ id, userId }) => {
  const { section } = await models.task.findByPk(id, {
    include: [
      {
        model: models.section,
        attribute: [],
        include: [
          {
            model: models.project,
            attributes: ['creatorId'],
            where: { creatorId: userId },
          },
        ],
      },
    ],
  });

  return !!section;
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
