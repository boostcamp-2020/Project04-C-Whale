const router = require('express').Router();
const { authenticateUser } = require('@utils/auth');
const labelController = require('@controllers/label');

router.get('/', authenticateUser, labelController.getAllLabels);

router.post('/', authenticateUser, labelController.isValidPostDatas, labelController.createLabel);

module.exports = router;
