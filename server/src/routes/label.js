const router = require('express').Router();
const labelController = require('@controllers/label');

// TODO: 리팩토링 해야한다
// controller에서 validation check는 받은 정보가 맞는 타입인지만 체크
// middle ware는 controller로 가는 과정에서 체크되거나 추가되는 정보
// 아래에 own label이나 이런 것들은 서비스에서 책임을 져야한다.
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
