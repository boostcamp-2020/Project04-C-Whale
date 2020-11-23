const router = require('express').Router();

const { models } = require('@models');
const { responseHandler } = require('@utils/handler');

router.get('/user/me', async (req, res) => {
  const user = { id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329' };
  const foundUser = await models.user.findOne(user.id);
  delete user.dataValues.createdAt;
  delete user.dataValues.updatedAt;
  responseHandler(res, 200, foundUser);
});

module.exports = router;
