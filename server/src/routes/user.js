const router = require('express').Router();

const { models } = require('@models');
const { responseHandler } = require('@utils/handler');
const { passportNaverAuthenticate } = require('@utils/auth');
const userController = require('@controllers/user');

router.get('/oauth/naver', passportNaverAuthenticate);
router.get('/oauth/naver/callback', passportNaverAuthenticate, userController.naverLogin);

router.get('/me', async (req, res) => {
  // client 로그인 view 개발 이후, token 해석하는 로직 추가하기
  const user = { id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329' };
  const foundUser = await models.user.findOne(user.id);
  delete user.dataValues.createdAt;
  delete user.dataValues.updatedAt;
  responseHandler(res, 200, foundUser);
});

module.exports = router;
