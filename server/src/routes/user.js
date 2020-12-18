const router = require('express').Router();
const {
  passportNaverAuthenticate,
  passportGoogleAuthenticate,
  authenticateUser,
} = require('@utils/auth');
const userController = require('@controllers/user');

// TODO: refresh token 구현
router.get('/oauth/naver', passportNaverAuthenticate);
router.get('/oauth/naver/callback', passportNaverAuthenticate, userController.naverLogin);

router.get('/oauth/google', passportGoogleAuthenticate);
router.get('/oauth/google/callback', passportGoogleAuthenticate, userController.googleLogin);

router.get('/me', authenticateUser, userController.getOwnInfo);

module.exports = router;
