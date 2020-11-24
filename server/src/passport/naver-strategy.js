const NaverStrategy = require('passport-naver').Strategy;
// const userService = require('@services/user');
const userModel = require('@models').models.user;

const data = {
  clientID: process.env.NAVER_CLIENT_ID,
  clientSecret: process.env.NAVER_CLIENT_SECRET,
  callbackURL: process.env.NAVER_CALLBACK_URL,
};

const getNaverUser = async (accessToken, refreshToken, profile, done) => {
  const NAVER = 'naver';
  try {
    const { email, nickname } = profile._json;

    // let user = await userService.retrieveByEmail(email, NAVER);
    let user = await userModel.findOne(
      { where: { email, provider: NAVER } },
      {
        attributes: ['id', 'email', 'name', 'provider'],
      },
    );

    if (!user) {
      user = await userModel.create({
        email,
        name: nickname,
        provider: NAVER,
      });
    }

    return done(null, user);
  } catch (err) {
    throw Error(err);
  }
};

module.exports = passport => {
  passport.use(new NaverStrategy(data, getNaverUser));
};
