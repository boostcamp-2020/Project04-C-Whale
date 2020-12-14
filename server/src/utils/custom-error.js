const status = {
  BAD_REQUEST_ERROR: 400,
  UNAUTHORIZED_ERROR: 401,
  FORBIDDEN_ERROR: 403,
  NOT_FOUND_ERROR: 404,
  INTERNAL_SERVER_ERROR: 500,
};

const message = {
  // 400
  TYPE_ERROR: property => `${property} 타입이 올바르지 않습니다.`,
  NECESSARY_INPUT_ERROR: property => `${property}을(를) 입력해주세요.`,
  UNNECESSARY_INPUT_ERROR: property => `불필요한 값이 포함되어 있습니다. => ${property}`,
  INVALID_INPUT_ERROR: property => `${property}값이 올바르지 않습니다.`,
  WRONG_RELATION_ERROR: relation => `요청하신 데이터의 연관관계가 잘못됐습니다. ${relation}`,
  DUEDATE_ERROR: () => 'dueDate는 현재시간보다 이전을 설정할 수 없습니다.',
  // 401
  UNAUTHORIZED_ERROR: '인증되지 않은 사용자입니다.',
  INVALID_TOKEN_ERROR: '토큰 값이 잘못되었습니다.',
  // 403
  FORBIDDEN_ERROR: property => `${property}에 접근 권한이 없습니다.`,
  // 404
  NOT_FOUND_ERROR: property => `존재하지 않는 ${property}입니다.`,
  // 500
  INTERNAL_SERVER_ERROR: '서버 내부에 에러가 발생했습니다. 잠시 후 다시 시도해주세요',
};

const code = {
  VALIDATION_ERROR: 'ValidationError',
  INVALID_PARAM_ERROR: 'InvalidParameterError',
  UNAUTHORIZED_ERROR: 'UnauthorizedError',
  INVALID_TOKEN_ERROR: 'InvalidTokenError',
  FORBIDDEN_ERROR: 'ForbiddenError',
  NOT_FOUND_ERROR: 'NotFoundError',
  INTERNAL_SERVER_ERROR: 'InternalServerError',
};

const customError = {
  // validation error
  TYPE_ERROR: property => {
    const error = new Error(message.TYPE_ERROR(property));
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    return error;
  },
  NECESSARY_INPUT_ERROR: property => {
    const error = new Error(message.NECESSARY_INPUT_ERROR(property));
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    return error;
  },
  UNNECESSARY_INPUT_ERROR: property => {
    const error = new Error(message.UNNECESSARY_INPUT_ERROR(property));
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    return error;
  },
  INVALID_INPUT_ERROR: property => {
    const error = new Error(message.INVALID_INPUT_ERROR(property));
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    return error;
  },
  DUEDATE_ERROR: () => {
    const error = new Error(message.DUEDATE_ERROR);
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    return error;
  },
  // invalid params error
  WRONG_RELATION_ERROR: relation => {
    const error = new Error(message.WRONG_RELATION_ERROR(relation));
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.INVALID_PARAM_ERROR;
    return error;
  },
  // unauthorized error
  UNAUTHORIZED_ERROR: () => {
    const error = new Error(message.UNAUTHORIZED_ERROR);
    error.status = status.UNAUTHORIZED_ERROR;
    error.code = code.UNAUTHORIZED_ERROR;
    return error;
  },
  // invalid toekn error
  INVALID_TOKEN_ERROR: () => {
    const error = new Error(message.INVALID_TOKEN_ERROR);
    error.status = status.UNAUTHORIZED_ERROR;
    error.code = code.INVALID_TOKEN_ERROR;
    return error;
  },
  // forbidden error
  FORBIDDEN_ERROR: property => {
    const error = new Error(message.FORBIDDEN_ERROR(property));
    error.status = status.FORBIDDEN_ERROR;
    error.code = code.FORBIDDEN_ERROR;
    return error;
  },
  // notfound error
  NOT_FOUND_ERROR: property => {
    const error = new Error(message.NOT_FOUND_ERROR(property));
    error.status = status.NOT_FOUND_ERROR;
    error.code = code.NOT_FOUND_ERROR;
    return error;
  },
  // internal server error
  INTERNAL_SERVER_ERROR: () => {
    const error = new Error(message.INTERNAL_SERVER_ERROR);
    error.status = status.INTERNAL_SERVER_ERROR;
    error.code = code.INTERNAL_SERVER_ERROR;
    return error;
  },
};

module.exports = { customError, message };
