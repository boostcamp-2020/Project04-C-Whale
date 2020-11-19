require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');

describe('login API test', () => {
  //   const NAVER_URL = 'api/user/oauth/naver';
  const NAVER_URL = '/';
  it('token check', done => {
    // given
    const expectedToken = 'Bearer tokenString';
    const expectedStatus = 200;
    const expectedMSG = 'ok';

    try {
      request(app)
        .get(NAVER_URL) // when
        .end((err, res) => {
          if (err) {
            throw err;
          }
          const { token, message } = res.body;
          const { status } = res.headers;
          // then
          expect(status).toBe(expectedStatus);
          expect(token).toBe(expectedToken);
          expect(message).toBe(expectedMSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
