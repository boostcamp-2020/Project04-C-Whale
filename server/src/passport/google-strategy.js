const GoogleStrategy = require('passport-google-oauth20');
const userService = require('@services/user');
const { models } = require('@models');

const data = {
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: process.env.GOOGLE_CALLBACK_URL,
};

const getGoogleUser = async (accessToken, refreshToken, profile, done) => {
  const GOOGLE = 'google';
  try {
    const { email, nickname: name } = profile._json;
    const [user] = await userService.retrieveOrCreate({ email, name, provider: GOOGLE });
    await models.project.findOrCreate({
      where: { creatorId: user.id },
      defaults: { creatorId: user.id, title: '관리함', isList: true },
    });

    return done(null, user.toJSON());
  } catch (err) {
    throw Error(err);
  }
};

module.exports = passport => {
  passport.use(new GoogleStrategy(data, getGoogleUser));
};
