const router = require('express').Router();

const { models } = require('@models');
const { responseHandler } = require('@utils/handler');
const labelRouter = require('@routes/label');
const userRouter = require('@routes/user');

router.use('/user', userRouter);

router.use('/label', labelRouter);

module.exports = router;
