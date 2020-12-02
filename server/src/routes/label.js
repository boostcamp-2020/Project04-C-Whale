const router = require('express').Router();
const labelController = require('@controllers/label');

router.get('/', labelController.getAllLabels);
router.post('/', labelController.isValidRequestDatas, labelController.createLabel);
router.put(
  '/:labelId',
  labelController.isValidRequestDatas,
  labelController.isValidLabelId,
  labelController.isOwnLabel,
  labelController.updateLabel,
);
router.delete(
  '/:labelId',
  labelController.isValidLabelId,
  labelController.isOwnLabel,
  labelController.removeLabel,
);

module.exports = router;
