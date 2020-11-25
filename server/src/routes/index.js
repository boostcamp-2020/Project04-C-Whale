const router = require('express').Router();

const userRouter = require('@routes/user');
const taskRouter = require('@routes/task');
const projectRouter = require('@routes/project');
const labelRouter = require('@routes/label');

router.use('/user', userRouter);
router.use('/task', taskRouter);
router.use('/project', projectRouter);
router.use('/label', labelRouter);

module.exports = router;
