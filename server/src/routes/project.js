const router = require('express').Router();
const projectController = require('@controllers/project');
const sectionController = require('@controllers/section');
const taskController = require('@controllers/task');

router.get('/', projectController.getProjects);
router.post('/', projectController.createProject);
router.get('/:projectId', projectController.getProjectById);
router.put('/:projectId', projectController.updateProject);
router.patch('/:projectId', projectController.updateProject);
router.delete('/:projectId', projectController.deleteProject);

router.post('/:projectId/section', sectionController.createSection);
router.put('/:projectId/section/:sectionId', sectionController.updateSection);
router.patch('/:projectId/section/position', projectController.updateSectionPositions);
router.delete('/:projectId/section/:sectionId', sectionController.deleteSection);
router.patch('/:projectId/section/:sectionId/task/position', sectionController.updateTaskPositions);

router.post('/:projectId/section/:sectionId/task', taskController.createTask);

module.exports = router;
