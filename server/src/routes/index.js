const express = require('express');

const router = express.Router();

const { models } = require('@models');

router.get('/', (req, res, next) => {
  res.json();
});

router.get('/user', async (req, res) => {
  const users = await models.user.findAll();
  res.json(users);
});

router.get('/label', async (req, res) => {
  const labels = await models.label.findAll();
  res.json(labels);
});

module.exports = router;
