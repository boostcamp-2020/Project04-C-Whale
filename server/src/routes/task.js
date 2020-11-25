const router = require('express').Router();
const taskController = require('@controllers/task');

router.get('/:taskId', taskController.getTaskById);
router.post('/', taskController.createOrUpdateTask);
router.post('/:taskId', taskController.createOrUpdateTask);
router.delete('/:taskId', taskController.deleteTask);

module.exports = router;
