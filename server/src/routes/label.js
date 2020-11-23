const router = require('express').Router();

const { models } = require('@models');
const { responseHandler } = require('@utils/handler');

router.get('/', async (req, res, next) => {
  const labels = await models.label.findAll();
  res.json(labels);
});

router.post('/', async (req, res) => {
  const { id: userId } = req.user || { id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329' };
  const { color, title } = req.body;
  const result = await models.label.create({ userId, color, title });

  responseHandler(res, 200);
});

module.exports = router;
