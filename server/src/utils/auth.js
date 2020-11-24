const jwt = require('jsonwebtoken');
const passport = require('passport');

const TOKEN_HEADER = 'Bearer';

const createJWT = user => {
  return `${TOKEN_HEADER} ${jwt.sign(user, process.env.JWT_SECRET, {
    expiresIn: '1h',
  })}`;
};

const passportNaverAuthenticate = passport.authenticate('naver', { session: false });

module.exports = { createJWT, passportNaverAuthenticate };
