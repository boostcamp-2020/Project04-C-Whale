require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');

jest.mock('@models', () => {
  // 추후 global setting 으로 한번에 설정하는 방안 생각
  const connection = require('@test/sequelize-mock');
  return connection;
});

const SUCCESS_CODE = 200;
const SUCCESS_MSG = 'ok';

describe('label api', () => {
  it('label post', done => {
    // given
    const expectedLabel = {
      title: 'BE',
      color: '#FFFFFF',
    };

    try {
      request(app)
        .post('/api/label') // when
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          expect(res.status).toBe(SUCCESS_CODE);
          expect(res.body.message).toBe(SUCCESS_MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
