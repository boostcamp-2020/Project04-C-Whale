const express = require('express');

const router = express.Router();

const { models } = require('@models');
const { responseHandler } = require('@utils/handler');

router.get('/', (req, res, next) => {
  res.json();
});

router.get('/user/me', async (req, res) => {
  const user = { id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329' };
  const foundUser = await models.user.findOne(user.id);
  delete user.dataValues.createdAt;
  delete user.dataValues.updatedAt;
  res.json(user);
});

router.get('/label', async (req, res) => {
  const labels = await models.label.findAll();
  res.json(labels);
});

router.post('/api/label', async (req, res) => {
  const { id: userId } = req.user || { id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329' };
  const { color, title } = req.body;
  const result = await models.label.create({ userId, color, title });

  responseHandler(res, 200);
});

module.exports = router;
