const router = require('express').Router();
const projectController = require('@controllers/project');
const sectionsController = require('@controllers/section');

// TODO: today 반환하는 라우터, validation check
// router.get('/today', projectController.getTodayProject);
router.get('/', projectController.getProjects);
router.post('/', projectController.createProject);
router.get('/:projectId', projectController.getProjectById);
router.put('/:projectId', projectController.updateProject);
router.patch('/:projectId', projectController.updateProject);
router.delete('/:projectId', projectController.deleteProject);

router.post('/:projectId/section', sectionsController.createSection);
router.put('/:projectId/section/:sectionId', sectionsController.updateSection);
router.delete('/:projectId/section/:sectionId', sectionsController.deleteSection);
router.post('/:projectId/section/:sectionId/task', sectionsController.updateTaskPositions);

module.exports = router;
