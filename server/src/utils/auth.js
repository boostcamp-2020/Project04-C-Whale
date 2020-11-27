const jwt = require('jsonwebtoken');
const passport = require('passport');
const { errorHandler } = require('@utils/handler');

const TOKEN_HEADER = 'Bearer';

const createJWT = user => {
  return `${TOKEN_HEADER} ${jwt.sign(user, process.env.JWT_SECRET, {
    expiresIn: '1h',
  })}`;
};

const passportNaverAuthenticate = passport.authenticate('naver', { session: false });

const authenticateUser = (req, res, next) => {
  passport.authenticate('jwt', { session: false }, (err, user) => {
    try {
      if (err) {
        throw err; // 토큰 값 자체를 해석할 수 없는 경우
      }
      if (!user) {
        return errorHandler(res, 401, 'Unauthorized'); // 토큰 값으로 부터 유저를 찾을 수 없는 경우
      }
      req.user = user;
      return next();
    } catch (error) {
      return next(err);
    }
  })(req, res, next);
};

module.exports = { createJWT, passportNaverAuthenticate, authenticateUser };
