const { responseHandler } = require('@utils/handler');
const { createJWT } = require('@utils/auth');
const { asyncTryCatch } = require('@utils/async-try-catch');

const naverLogin = asyncTryCatch(async (req, res) => {
  const { CLIENT_URL, CLIENT_IOS_URL } = process.env;
  const { user } = req;
  const token = createJWT(user);

  res.header('Authentication', token);
  const userAgent = req.headers['user-agent'];
  if (userAgent.includes('iPhone')) {
    res.status(200).redirect(`${CLIENT_IOS_URL}?token=${token}`);
  } else {
    res.status(200).redirect(`${CLIENT_URL}?token=${token}`);
  }
});

const googleLogin = asyncTryCatch(async (req, res) => {
  const { CLIENT_URL, CLIENT_IOS_URL } = process.env;
  const { user } = req;
  const token = createJWT(user);

  res.header('Authentication', token);
  const userAgent = req.headers['user-agent'];
  if (userAgent.includes('iPhone')) {
    res.status(200).redirect(`${CLIENT_IOS_URL}?token=${token}`);
  } else {
    res.status(200).redirect(`${CLIENT_URL}?token=${token}`);
  }
});

const getOwnInfo = asyncTryCatch(async (req, res) => {
  const { user } = req;
  responseHandler(res, 200, { user, test: "test" });
});

module.exports = { naverLogin, googleLogin, getOwnInfo };
