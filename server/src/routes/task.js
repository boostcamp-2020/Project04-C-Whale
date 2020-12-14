const router = require('express').Router();
const taskController = require('@controllers/task');
const commentController = require('@controllers/comment');
const bookmarkController = require('@controllers/bookmark');

router.get('/', taskController.getAllTasks);
router.get('/:taskId', taskController.getTaskById);
router.patch('/:taskId', taskController.updateTask);
router.patch('/:taskId/position', taskController.updateChildTaskPositions);
router.delete('/:taskId', taskController.deleteTask);

router.get('/:taskId/comment', commentController.getComments);
router.post('/:taskId/comment', commentController.createComment);
router.put('/:taskId/comment/:commentId', commentController.updateComment);
router.delete('/:taskId/comment/:commentId', commentController.deleteComment);

router.get('/:taskId/bookmark', bookmarkController.getBookmarks);
router.post('/:taskId/bookmark', bookmarkController.createBookmark);

module.exports = router;
