const { responseHandler } = require('@utils/handler');
const taskService = require('@services/task');
const labelService = require('@services/label');

const createTask = async (req, res, next) => {
  const { labelIdList, ...rest } = req.body;

  const newTask = await taskService.createTask(rest);
  await labelService.assignLabelToTask(newTask, labelIdList);

  responseHandler(res, 201, { message: 'ok', id: newTask.id });
};

module.exports = { createTask };
