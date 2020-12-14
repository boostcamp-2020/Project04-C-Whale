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

const isCommentOwner = async ({ id, userId }) => {
  const comment = await models.comment.findByPk(id, {
    include: [
      {
        model: models.task,
        attribute: [],
        include: [
          {
            model: models.section,
            attribute: [],
            include: [
              {
                model: models.project,
                attributes: ['creatorId'],
              },
            ],
          },
        ],
      },
    ],
    having: { 'task.section.project.creatorId': userId },
  });

  return !!comment;
};

module.exports = { isTaskOwner, isProjectOwner, isSectionOwner, isCommentOwner };
