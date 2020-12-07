const taskService = require('@services/task');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');
const { isValidDueDate } = require('@utils/date');

const getTaskById = asyncTryCatch(async (req, res) => {
  const task = await taskService.retrieveById(req.params.taskId);

  responseHandler(res, 200, task);
});

const getAllTasks = asyncTryCatch(async (req, res) => {
  const tasks = await taskService.retrieveAll(req.user.id);

  responseHandler(res, 200, { tasks });
});

const createTask = asyncTryCatch(async (req, res) => {
  const { dueDate } = req.body;

  // TODO middle ware로 빼내는게 좋을 것 같음
  if (!isValidDueDate(dueDate)) {
    const err = new Error('유효하지 않은 dueDate');
    err.status = 400;
    throw err;
  }

  const { projectId, sectionId } = req.params;
  await taskService.create({ projectId, sectionId, ...req.body });
  responseHandler(res, 201, { message: 'ok' });
});

const updateTask = asyncTryCatch(async (req, res) => {
  const { dueDate } = req.body;

  if (!isValidDueDate(dueDate)) {
    const err = new Error('유효하지 않은 dueDate');
    err.status = 400;
    throw err;
  }

  const { taskId } = req.params;

  await taskService.update({ id: taskId, ...req.body });
  responseHandler(res, 200, { message: 'ok' });
});

const deleteTask = asyncTryCatch(async (req, res) => {
  await taskService.remove(req.params.taskId);
  responseHandler(res, 200, { message: 'ok' });
});

module.exports = { getTaskById, getAllTasks, createTask, updateTask, deleteTask };
