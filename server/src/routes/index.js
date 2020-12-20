const router = require('express').Router();

const userRouter = require('@routes/user');
const taskRouter = require('@routes/task');
const projectRouter = require('@routes/project');

const { authenticateUser } = require('@utils/auth');

router.use('/user', userRouter);
router.use('/task', authenticateUser, taskRouter);
router.use('/project', authenticateUser, projectRouter);

module.exports = router;
