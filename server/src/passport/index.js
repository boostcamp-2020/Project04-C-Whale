const naverStrategy = require('@passport/naver-strategy');
const jwtStrategy = require('@passport/jwt-strategy');

module.exports = passport => {
  naverStrategy(passport);
  jwtStrategy(passport);
};
