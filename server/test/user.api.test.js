require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const { createJWT } = require('@utils/auth');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('user api', () => {
  it('users me', done => {
    // given
    const expectedUser = (() => {
      const { createdAt: deletedKey, updatedAt: deletedKey2, ...rest } = seeder.users[0];
      return rest;
    })();

    try {
      request(app)
        .get('/api/user/me') // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          const user = res.body;
          // then
          expect(user).toStrictEqual(expectedUser);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
