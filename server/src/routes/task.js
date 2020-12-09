const router = require('express').Router();
const taskController = require('@controllers/task');
const commentController = require('@controllers/comment');

router.get('/', taskController.getAllTasks);
router.get('/:taskId', taskController.getTaskById);
router.patch('/:taskId', taskController.updateTask);
router.delete('/:taskId', taskController.deleteTask);

router.get('/:taskId/comment', commentController.getComments);
router.post('/:taskId/comment', commentController.createComment);
router.put('/:taskId/comment/:commentId', commentController.updateComment);
router.delete('/:taskId/comment/:commentId', commentController.deleteComment);

module.exports = router;
