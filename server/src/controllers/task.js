const TaskDto = require('@models/dto/task');
const taskService = require('@services/task');
const { validator, getTypeError } = require('@utils/validator');
const { asyncTryCatch } = require('@utils/async-try-catch');
const { responseHandler } = require('@utils/handler');
const ParamsValidator = require('@utils/params-validator');

const getTaskById = asyncTryCatch(async (req, res) => {
  const id = req.params.taskId;
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const task = await taskService.retrieveById({ id, userId: req.user.id });

  responseHandler(res, 200, { task });
});

const getAllTasks = asyncTryCatch(async (req, res) => {
  const tasks = await taskService.retrieveAll(req.user.id);

  responseHandler(res, 200, { tasks });
});

const createTask = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(TaskDto, req.body);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }
  const { projectId, sectionId } = req.params;
  const task = { ...req.body, projectId, sectionId, userId: req.user.id };

  await taskService.create(task);
  responseHandler(res, 201, { message: 'ok' });
});

const updateTask = asyncTryCatch(async (req, res) => {
  const { taskId } = req.params;
  const task = { ...req.body };

  try {
    await validator(ParamsValidator, req.params);
    await validator(TaskDto, task, { groups: ['patch'] });
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  await taskService.update({ id: taskId, userId: req.user.id, ...task });
  responseHandler(res, 200, { message: 'ok' });
});

const updateChildTaskPositions = asyncTryCatch(async (req, res) => {
  const parentId = req.params.taskId;
  await taskService.updateChildTaskPositions(parentId, req.body.orderedTasks);

  responseHandler(res, 200, { message: 'ok' });
});

const deleteTask = asyncTryCatch(async (req, res) => {
  await validator(ParamsValidator, req.params);
  await taskService.remove(req.params.taskId);
  responseHandler(res, 200, { message: 'ok' });
});

module.exports = {
  getTaskById,
  getAllTasks,
  createTask,
  updateTask,
  deleteTask,
  updateChildTaskPositions,
};
