const { responseHandler, errorHandler } = require('@utils/handler');
const { isValidDueDate } = require('@utils/date');
const taskService = require('@services/task');
const labelService = require('@services/label');

const createTask = async (req, res) => {
  try {
    const { labelIdList, dueDate, ...rest } = req.body;

    const newTask = await taskService.createTask(dueDate, rest);
    await labelService.assignLabelToTask(newTask, labelIdList);
    responseHandler(res, 201, { message: 'ok', id: newTask.id });
  } catch (err) {
    errorHandler(res, 400, { message: err.message });
  }
};

module.exports = { createTask };
