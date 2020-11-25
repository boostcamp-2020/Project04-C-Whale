const router = require('express').Router();
const taskController = require('@controllers/task');

router.get('/:taskId', taskController.getTaskById);
router.post('/', taskController.createOrUpdateTask);
router.post('/:taskId', taskController.createOrUpdateTask);

module.exports = router;
