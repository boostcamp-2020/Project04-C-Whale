const NaverStrategy = require('passport-naver').Strategy;
const userService = require('@services/user');
const { models } = require('@models');

const data = {
  clientID: process.env.NAVER_CLIENT_ID,
  clientSecret: process.env.NAVER_CLIENT_SECRET,
  callbackURL: process.env.NAVER_CALLBACK_URL,
};

const getNaverUser = async (accessToken, refreshToken, profile, done) => {
  const NAVER = 'naver';
  try {
    const { email, nickname } = profile._json;
    const [user] = await userService.retrieveOrCreate({ email, nickname, provider: NAVER });
    await models.project.findOrCreate({
      where: { title: '관리함', creatorId: user.id, isList: true },
    });
    return done(null, user.toJSON());
  } catch (err) {
    throw Error(err);
  }
};

module.exports = passport => {
  passport.use(new NaverStrategy(data, getNaverUser));
};
