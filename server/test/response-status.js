const SUCCESS = {
  CODE: 200,
  POST: {
    CODE: 201,
  },
  MSG: 'ok',
};

const BAD_REQUEST = {
  CODE: 400,
  MSG: 'Bad Request',
};
const UNAUTHORIZED = {
  CODE: 401,
  MSG: 'Unauthorized',
};

const FORBIDDEN = {
  CODE: 403,
  MSG: 'Forbidden',
};

const NOT_FOUND = {
  CODE: 404,
  MSG: 'Not Found',
};
module.exports = { SUCCESS, UNAUTHORIZED, BAD_REQUEST, FORBIDDEN, NOT_FOUND };
