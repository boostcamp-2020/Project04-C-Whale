const naverStrategy = require('@passport/naver-strategy');
const googleStrategy = require('@passport/google-strategy');
const jwtStrategy = require('@passport/jwt-strategy');

module.exports = passport => {
  naverStrategy(passport);
  googleStrategy(passport);
  jwtStrategy(passport);
};
