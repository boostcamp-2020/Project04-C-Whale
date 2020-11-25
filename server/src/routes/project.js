const router = require('express').Router();
const projectController = require('@controllers/project');

router.get('/', projectController.getProjects);
router.get('/:projectId', projectController.getProjectById);
router.post('/', projectController.createProject);
router.put('/:projectId', projectController.updateProject);
router.patch('/:projectId', projectController.updateProject);
router.delete('/:projectId', projectController.deleteProject);

router.post('/:projectId/section', projectController.createSection);
router.put('/:projectId/section/:sectionId', projectController.updateSection);
router.delete('/:projectId/section/:sectionId', projectController.deleteSection);

module.exports = router;
