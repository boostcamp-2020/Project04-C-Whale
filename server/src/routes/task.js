const router = require('express').Router();
const taskController = require('@controllers/task');

router.post('/', taskController.createTask);

module.exports = router;
