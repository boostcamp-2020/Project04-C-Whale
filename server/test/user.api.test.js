require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const expectedData = require('@test/mock-seed');

jest.mock('@models', () => {
  // 추후 global setting 으로 한번에 설정하는 방안 생각
  const connection = require('@test/sequelize-mock');
  return connection;
});

describe('user api', () => {
  it('users me', done => {
    // given
    const expectedUser = expectedData.users[0];

    try {
      request(app)
        .get('/user/me') // when
        .end((err, res) => {
          if (err) {
            throw err;
          }
          const user = res.body;
          expect(user).toStrictEqual(expectedUser);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
