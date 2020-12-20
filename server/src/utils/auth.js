const jwt = require('jsonwebtoken');
const passport = require('passport');
const { errorHandler } = require('@utils/handler');
const { customError } = require('@utils/custom-error');

const createJWT = user => {
  return `${jwt.sign(user, process.env.JWT_SECRET, {
    // expiresIn: '1h',
  })}`;
};

const passportNaverAuthenticate = passport.authenticate('naver', { session: false });

const passportGoogleAuthenticate = passport.authenticate('google', {
  scope: ['profile', 'email'],
  session: false,
});

const authenticateUser = (req, res, next) => {
  passport.authenticate('jwt', { session: false }, (err, user) => {
    try {
      if (err) {
        throw customError.INTERNAL_SERVER_ERROR(); // passport 내부적인 에러
      }
      if (!user) {
        const error = customError.UNAUTHORIZED_ERROR();
        return errorHandler(res, error); // 토큰 값으로 부터 유저를 찾을 수 없는 경우
      }
      req.user = user;
      return next();
    } catch (error) {
      return next(err);
    }
  })(req, res, next);
};

module.exports = {
  createJWT,
  passportNaverAuthenticate,
  passportGoogleAuthenticate,
  authenticateUser,
};
