const { validateOrReject } = require('class-validator');
const { plainToClass } = require('class-transformer');

const validator = async (Dto, object, options) => {
  const classObject = plainToClass(Dto, object);
  await validateOrReject(classObject, options);
};

module.exports = validator;
