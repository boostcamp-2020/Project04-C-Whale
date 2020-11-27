const router = require('express').Router();
const { authenticateUser } = require('@utils/auth');
const labelController = require('@controllers/label');

router.get('/', authenticateUser, labelController.getAllLabels);
router.post(
  '/',
  authenticateUser,
  labelController.isValidRequestDatas,
  labelController.createLabel,
);
router.put(
  '/:labelId',
  authenticateUser,
  labelController.isValidRequestDatas,
  labelController.isValidLabelId,
  labelController.isOwnLabel,
  labelController.updateLabel,
);
router.delete(
  '/:labelId',
  authenticateUser,
  labelController.isValidLabelId,
  labelController.isOwnLabel,
  labelController.removeLabel,
);

module.exports = router;
