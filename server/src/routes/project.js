const router = require('express').Router();
const projectController = require('@controllers/project');
const sectionController = require('@controllers/section');
const taskController = require('@controllers/task');

// TODO: today 반환하는 라우터, validation check
router.get('/today', projectController.getTodayProject);
router.get('/', projectController.getProjects);
router.post('/', projectController.createProject);
router.get('/:projectId', projectController.getProjectById);
router.put('/:projectId', projectController.updateProject);
router.patch('/:projectId', projectController.updateProject);
router.delete('/:projectId', projectController.deleteProject);

router.post('/:projectId/section', sectionController.createSection);
router.put('/:projectId/section/:sectionId', sectionController.updateSection);
router.delete('/:projectId/section/:sectionId', sectionController.deleteSection);
router.post('/:projectId/section/:sectionId/task/position', sectionController.updateTaskPositions);

router.post('/:projectId/section/:sectionId/task', taskController.createTask);

module.exports = router;
