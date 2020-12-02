const taskModel = require('@models').models.task;
const commentModel = require('@models').models.comment;

const retrieveAllByTaskId = async taskId => {
  const task = await taskModel.findByPk(taskId);
  const comments = await task.getComments();

  return comments;
};

const create = async (taskId, commentData) => {
  const result = await commentModel.create({ ...commentData, taskId });

  return result;
};

const update = async (id, data) => {
  const result = await commentModel.update(data, { where: { id } });

  return result;
};

const remove = async id => {
  const result = await commentModel.destroy({
    where: { id },
  });
  return result;
};

module.exports = { retrieveAllByTaskId, create, update, remove };
