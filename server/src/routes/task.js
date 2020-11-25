const router = require('express').Router();
const taskController = require('@controllers/task');

router.get('/:taskId', taskController.getTaskById);
router.post('/', taskController.createTask);

module.exports = router;
