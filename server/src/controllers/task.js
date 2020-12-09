const TaskDto = require('@models/dto/task');
const taskService = require('@services/task');
const { validator, getErrorMsg } = require('@utils/validator');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');

const getTaskById = asyncTryCatch(async (req, res) => {
  const id = req.params.taskId;
  try {
    await validator(TaskDto, { id }, { groups: ['retrieve'] });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  const task = await taskService.retrieveById(id);

  responseHandler(res, 200, { task });
});

const getAllTasks = asyncTryCatch(async (req, res) => {
  const tasks = await taskService.retrieveAll(req.user.id);

  responseHandler(res, 200, { tasks });
});

const createTask = asyncTryCatch(async (req, res) => {
  try {
    await validator(TaskDto, req.body, { groups: ['create'] });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }
  const { projectId, sectionId } = req.params;
  const task = { ...req.body, projectId, sectionId };

  await taskService.create(task);
  responseHandler(res, 201, { message: 'ok' });
});

const updateTask = asyncTryCatch(async (req, res) => {
  const { taskId } = req.params;
  const task = { ...req.body };

  try {
    await validator(TaskDto, task, { groups: ['patch'] });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  await taskService.update({ id: taskId, ...task });
  responseHandler(res, 200, { message: 'ok' });
});

const deleteTask = asyncTryCatch(async (req, res) => {
  await taskService.remove(req.params.taskId);
  responseHandler(res, 200, { message: 'ok' });
});

module.exports = { getTaskById, getAllTasks, createTask, updateTask, deleteTask };
