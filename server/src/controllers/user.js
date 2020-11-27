const { responseHandler } = require('@utils/handler');
const { createJWT } = require('@utils/auth');

const naverLogin = (req, res, next) => {
  const clientURL =
    process.env.NODE_ENV === 'development'
      ? process.env.CLIENT_DOMAIN_DEVELOP
      : process.env.CLIENT_DOMAIN_PRODUCTION;
  try {
    const user = { req };
    const token = createJWT(user);
    res.header('Authentication', token);
    res.status(200).redirect(`${clientURL}?token=${token}`);
  } catch (err) {
    next(err);
  }
};

const getOwnInfo = (req, res, next) => {
  try {
    const { user } = req;
    responseHandler(res, 200, user);
  } catch (err) {
    next(err);
  }
};

module.exports = { naverLogin, getOwnInfo };
