const SectionDto = require('@models/dto/section');
const PositionDto = require('@models/dto/position');
const sectionService = require('@services/section');
const { validator, getTypeError } = require('@utils/validator');
const { responseHandler } = require('@utils/handler');
const { asyncTryCatch } = require('@utils/async-try-catch');
const ParamsValidator = require('@utils/params-validator');

const createSection = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(SectionDto, req.body);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }
  const { id: userId } = req.user;
  await sectionService.create({ ...req.body, ...req.params, userId });

  responseHandler(res, 201, { message: 'ok' });
});

const updateTaskPositions = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(PositionDto, req.body);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  await sectionService.updateTaskPositions({ ...req.body, ...req.params, userId });

  responseHandler(res, 200, { message: 'ok' });
});

const updateSection = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
    await validator(SectionDto, req.body);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  await sectionService.update({ ...req.body, ...req.params, userId });

  responseHandler(res, 200, { message: 'ok' });
});

const deleteSection = asyncTryCatch(async (req, res) => {
  try {
    await validator(ParamsValidator, req.params);
  } catch (errs) {
    const validationError = getTypeError(errs);
    throw validationError;
  }

  const { id: userId } = req.user;
  await sectionService.remove({ ...req.params, userId });

  responseHandler(res, 200, { message: 'ok' });
});

module.exports = {
  createSection,
  updateSection,
  updateTaskPositions,
  deleteSection,
};
