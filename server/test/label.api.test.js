require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
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
