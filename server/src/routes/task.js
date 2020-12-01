const router = require('express').Router();
const taskController = require('@controllers/task');
const { authenticateUser } = require('@utils/auth');

// router.get('/', )
router.get('/:taskId', authenticateUser, taskController.getTaskById);
router.post('/', authenticateUser, taskController.createTask);
router.patch('/:taskId', authenticateUser, taskController.updateTask);
router.delete('/:taskId', authenticateUser, taskController.deleteTask);

router.get('/:taskId/comment', authenticateUser, taskController.getComments);
router.post('/:taskId/comment', authenticateUser, taskController.createComment);
router.put('/:taskId/comment/:commentId', authenticateUser, taskController.updateComment);
router.delete('/:taskId/comment/:commentId', authenticateUser, taskController.deleteComment);

module.exports = router;
