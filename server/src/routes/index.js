const router = require('express').Router();

const labelRouter = require('@routes/label');
const userRouter = require('@routes/user');
const projectRouter = require('@routes/project');

router.use('/user', userRouter);
router.use('/label', labelRouter);
router.use('/project', projectRouter);

module.exports = router;
