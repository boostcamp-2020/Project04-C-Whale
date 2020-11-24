const { models } = require('@models');

const createTask = async ({ title, projectId, priorityId, alarmId, dueDate, parentId }) => {
  const newTask = await models.task.create({
    title,
    projectId,
    priorityId,
    alarmId,
    dueDate,
    parentId,
  });

  return newTask;
};

module.exports = { createTask };
