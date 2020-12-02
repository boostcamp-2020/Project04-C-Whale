const sectionService = require('@services/section');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');

const createSection = asyncTryCatch(async (req, res) => {
  await sectionService.create({ projectId: req.params.projectId, ...req.body });

  responseHandler(res, 201, { message: 'ok' });
});

const updateTaskPositions = asyncTryCatch(async (req, res) => {
  await sectionService.updateTaskPositions(req.body.orderedTasks);

  responseHandler(res, 200, { message: 'ok' });
});

const updateSection = asyncTryCatch(async (req, res) => {
  await sectionService.update({ id: req.params.sectionId, ...req.body });

  responseHandler(res, 200, { message: 'ok' });
});

const deleteSection = asyncTryCatch(async (req, res) => {
  await sectionService.remove(req.params.sectionId);

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = {
  createSection,
  updateSection,
  updateTaskPositions,
  deleteSection,
};
