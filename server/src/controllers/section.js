const SectionDto = require('@models/dto/section');
const sectionService = require('@services/section');
const { validator, getErrorMsg } = require('@utils/validator');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');

const createSection = asyncTryCatch(async (req, res) => {
  const { projectId } = req.params;
  try {
    await validator(SectionDto, req.body, { groups: ['create'] });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  // TODO projectId를 따로 빼야 하나 ?
  await sectionService.create({ projectId, ...req.body });

  responseHandler(res, 201, { message: 'ok' });
});

const updateTaskPositions = asyncTryCatch(async (req, res) => {
  await sectionService.updateTaskPositions(req.body.orderedTasks);

  responseHandler(res, 200, { message: 'ok' });
});

const updateSection = asyncTryCatch(async (req, res) => {
  const { sectionId } = req.params;

  try {
    await validator(SectionDto, req.body, { groups: ['update'] });
  } catch (errs) {
    const message = getErrorMsg(errs);
    const err = new Error(message);
    err.status = 400;
    throw err;
  }

  // TODO sectionId를 따로 빼야 하나 ?
  await sectionService.update({ id: sectionId, ...req.body });

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
