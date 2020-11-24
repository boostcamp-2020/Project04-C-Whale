const router = require('express').Router();
const projectController = require('@controllers/project');

router.get('/', projectController.getProjects);

module.exports = router;
