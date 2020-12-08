const { validateOrReject } = require('class-validator');
const { plainToClass } = require('class-transformer');

const validator = async (Dto, object, options) => {
  const classObject = plainToClass(Dto, object);
  await validateOrReject(classObject, { ...options, stopAtFirstError: true });
};

const getErrorMsg = errorArray => {
  const [validationError] = errorArray;
  const [message] = Object.values(validationError.constraints);

  return message;
};

module.exports = { validator, getErrorMsg };
