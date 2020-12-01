const { responseHandler } = require('@utils/handler');
const { createJWT } = require('@utils/auth');

const naverLogin = (req, res, next) => {
  const { CLIENT_URL } = process.env;
  try {
    const { user } = req;
    const token = createJWT(user);
    res.header('Authentication', token);
    res.status(200).redirect(`${CLIENT_URL}?token=${token}`);
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
