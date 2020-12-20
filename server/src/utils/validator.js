const { validateOrReject, registerDecorator } = require('class-validator');
const { plainToClass } = require('class-transformer');
const { isValidDueDate } = require('@utils/date');
const { customError } = require('@utils/custom-error');

const validator = async (Dto, object, options) => {
  const classObject = plainToClass(Dto, object);
  await validateOrReject(classObject, { ...options });
};

const getErrorByKey = ({ key, fileds }) => {
  let error;
  switch (key) {
    // TYPE ERRORS
    case 'isString':
    case 'isBoolean':
    case 'isInt':
    case 'isDateString':
      error = customError.TYPE_ERROR(fileds);
      break;
    // INVALID INPUT ERRORS
    case 'isUrl':
    case 'minLength':
    case 'isHexColor':
    case 'isUuid':
    case 'isEnum':
      error = customError.INVALID_INPUT_ERROR(fileds);
      break;
    case 'isDefined':
      error = customError.NECESSARY_INPUT_ERROR(fileds);
      break;
    case 'isEmpty':
      error = customError.UNNECESSARY_INPUT_ERROR(fileds);
      break;
    case 'isAfterToday':
      error = customError.DUEDATE_ERROR(fileds);
      break;
    default:
      break;
  }

  return error;
};

const getTypeError = errorArray => {
  if (errorArray.length > 1) {
    const fields = errorArray.map(error => {
      const { constraints } = error;
      return Object.values(constraints);
    });
    return customError.MULTIPLE_ERROR(fields.flat());
  }

  const [validationError] = errorArray;
  const constraintsKeys = Object.keys(validationError.constraints);

  if (constraintsKeys.length > 1) {
    const fields = constraintsKeys.map(key => {
      return validationError.constraints[key];
    });

    return customError.MULTIPLE_ERROR(fields);
  }

  const [key] = constraintsKeys;
  const fileds = [validationError.constraints[key]];
  const error = getErrorByKey({ key, fileds });

  return error;
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
