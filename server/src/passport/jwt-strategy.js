const JWTStrategy = require('passport-jwt').Strategy;
const { ExtractJwt } = require('passport-jwt');
const userModel = require('@models').models.user;

const jwtConfig = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken('authorization'),
  secretOrKey: process.env.JWT_SECRET,
};

const jwtVerify = async (payload, done) => {
  try {
    if (!payload.id) {
      const err = new Error('Bad Request');
      err.status = 400;
      throw err;
    }
    const user = await userModel.findByPk(payload.id);
    if (user) {
      done(null, user.dataValues);
    } else {
      done(null, false);
    }
  } catch (error) {
    done(error);
  }
};

module.exports = passport => {
  passport.use('jwt', new JWTStrategy(jwtConfig, jwtVerify));
};
