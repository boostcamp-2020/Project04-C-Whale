const jwt = require('jsonwebtoken');

const TOKEN_HEADER = 'Bearer';

const createJWT = user => {
  const { email, name, provider } = user;
  return `${TOKEN_HEADER} ${jwt.sign({ email, name, provider }, process.env.JWT_SECRET)}`;
};

module.exports = { createJWT };
