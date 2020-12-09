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

module.exports = { isTaskOwner };
