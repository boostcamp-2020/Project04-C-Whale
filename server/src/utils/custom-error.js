const status = {
  BAD_REQUEST_ERROR: 400,
  UNAUTHORIZED_ERROR: 401,
  FORBIDDEN_ERROR: 403,
  NOT_FOUND_ERROR: 404,
  INTERNAL_SERVER_ERROR: 500,
};

const message = {
  // 400
  TYPE_ERROR: () => '데이터 타입이 올바르지 않은 입력이 있습니다.',
  NECESSARY_INPUT_ERROR: () => '필요한 데이터가 누락되었습니다.',
  UNNECESSARY_INPUT_ERROR: () => '불필요한 데이터가 포함되어있습니다.',
  INVALID_INPUT_ERROR: () => `요청하신 데이터의 일부 값이 유효하지 않습니다.`,
  WRONG_RELATION_ERROR: () => '요청하신 데이터의 연관관계가 잘못됐습니다.',
  DUEDATE_ERROR: () => 'dueDate는 현재시간보다 이전을 설정할 수 없습니다.',
  MULTIPLE_ERROR: () => '요청에 대한 에러가 복합적으로 존재합니다.',
  // 401
  UNAUTHORIZED_ERROR: '인증되지 않은 사용자입니다. 네이버 로그인을 하신 후, 서비스를 이용해주세요.',
  INVALID_TOKEN_ERROR: '토큰 값이 잘못되었습니다.',
  // 403
  FORBIDDEN_ERROR: () => `할고래DO 서비스는 자신의 리소스에만 접근할 수 있습니다.`,
  // 404
  NOT_FOUND_ERROR: property => `요청하신 ${property}를 찾을 수 없습니다.`,
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
  MULTIPLE_ERROR: 'MultipleError',
};

const customError = {
  // validation error
  TYPE_ERROR: (fileds = {}) => {
    const error = new Error(message.TYPE_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    error.fileds = fileds;
    return error;
  },
  NECESSARY_INPUT_ERROR: (fileds = {}) => {
    const error = new Error(message.NECESSARY_INPUT_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    error.fileds = fileds;
    return error;
  },
  UNNECESSARY_INPUT_ERROR: (fileds = {}) => {
    const error = new Error(message.UNNECESSARY_INPUT_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    error.fileds = fileds;
    return error;
  },
  INVALID_INPUT_ERROR: (fileds = {}) => {
    const error = new Error(message.INVALID_INPUT_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    error.fileds = fileds;
    return error;
  },
  DUEDATE_ERROR: (fileds = {}) => {
    const error = new Error(message.DUEDATE_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.VALIDATION_ERROR;
    error.fileds = fileds;
    return error;
  },
  MULTIPLE_ERROR: (fileds = {}) => {
    const error = new Error(message.MULTIPLE_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.MULTIPLE_ERROR;
    error.fileds = fileds;
    return error;
  },
  // invalid params error
  WRONG_RELATION_ERROR: (fileds = {}) => {
    const error = new Error(message.WRONG_RELATION_ERROR());
    error.status = status.BAD_REQUEST_ERROR;
    error.code = code.INVALID_PARAM_ERROR;
    error.fileds = fileds;
    return error;
  },
  // unauthorized error
  UNAUTHORIZED_ERROR: (fileds = {}) => {
    const error = new Error(message.UNAUTHORIZED_ERROR);
    error.status = status.UNAUTHORIZED_ERROR;
    error.code = code.UNAUTHORIZED_ERROR;
    error.fileds = fileds;
    return error;
  },
  // invalid toekn error
  INVALID_TOKEN_ERROR: (fileds = {}) => {
    const error = new Error(message.INVALID_TOKEN_ERROR);
    error.status = status.UNAUTHORIZED_ERROR;
    error.code = code.INVALID_TOKEN_ERROR;
    error.fileds = fileds;
    return error;
  },
  // forbidden error
  FORBIDDEN_ERROR: (fileds = {}) => {
    const error = new Error(message.FORBIDDEN_ERROR());
    error.status = status.FORBIDDEN_ERROR;
    error.code = code.FORBIDDEN_ERROR;
    error.fileds = fileds;
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
  INTERNAL_SERVER_ERROR: (fileds = {}) => {
    const error = new Error(message.INTERNAL_SERVER_ERROR);
    error.status = status.INTERNAL_SERVER_ERROR;
    error.code = code.INTERNAL_SERVER_ERROR;
    error.fileds = fileds;
    return error;
  },
};

module.exports = { customError, message };
