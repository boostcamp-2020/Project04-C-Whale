const { validateOrReject, registerDecorator } = require('class-validator');
const { plainToClass } = require('class-transformer');
const { isValidDueDate } = require('@utils/date');

const validator = async (Dto, object, options) => {
  const classObject = plainToClass(Dto, object);
  await validateOrReject(classObject, { ...options, stopAtFirstError: true });
};

const getErrorMsg = errorArray => {
  const [validationError] = errorArray;
  const [message] = Object.values(validationError.constraints);

  return message;
};
const isAfterToday = (property, validationOptions) => {
  return (object, propertyName) => {
    registerDecorator({
      name: 'isAfterToday',
      target: object.constructor,
      propertyName,
      constraints: [property],
      options: validationOptions,
      validator: {
        validate(value, args) {
          return isValidDueDate(value); // you can return a Promise<boolean> here as well, if you want to make async validation
        },
      },
    });
  };
};

module.exports = { validator, getErrorMsg, isAfterToday };
