const router = require('express').Router();
const { authenticateUser } = require('@utils/auth');
const labelController = require('@controllers/label');

router.get('/', authenticateUser, labelController.getAllLabels);

// router.post('/', authenticateUser, async (req, res) => {
//   const { id: userId } = req.user || { id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329' };
//   const { color, title } = req.body;
//   const result = await models.label.create({ userId, color, title });

//   responseHandler(res, 200);
// });

module.exports = router;
