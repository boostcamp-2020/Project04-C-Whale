const { validateOrReject, registerDecorator } = require('class-validator');
const { plainToClass } = require('class-transformer');
const { isValidDueDate } = require('@utils/date');
const { message, customError } = require('@utils/custom-error');

const validator = async (Dto, object, options) => {
  const classObject = plainToClass(Dto, object);
  await validateOrReject(classObject, { ...options, stopAtFirstError: true });
};

const getTypeError = errorArray => {
  const [validationError] = errorArray;
  const { property } = validationError;
  const recievedErrorMessage = Object.values(validationError.constraints).shift();

  const errorKyes = Object.keys(message);
  const errorType = errorKyes.find(key => message[key](property) === recievedErrorMessage);
  return customError[errorType](property);
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

module.exports = { validator, getTypeError, isAfterToday };
