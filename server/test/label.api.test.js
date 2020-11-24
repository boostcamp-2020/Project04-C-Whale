require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const { createJWT } = require('@utils/auth');
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
const UNAUTHORIZED_CODE = 401;
const UNAUTHORIZED_MSG = 'Unauthorized';

describe('label api', () => {
  it('전체 label 조회 (token O)', done => {
    // given
    const expectedLabels = seeder.labels.map(label => {
      const copy = (() => {
        const {
          createdAt: deletedKey1,
          updatedAt: deletedKey2,
          userId: deletedKey3,
          ...rest
        } = label;
        return rest;
      })();
      return copy;
    });

    try {
      request(app)
        .get('/api/label') // when
        .set('Authorization', createJWT(seeder.users[0]))
        .end((err, res) => {
          if (err) {
            throw err;
          }
          const { labels } = res.body;
          // then
          expect(res.status).toBe(SUCCESS_CODE);
          expect(labels).toStrictEqual(expectedLabels);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('전체 label 조회 (token X)', done => {
    // given
    try {
      request(app)
        .get('/api/label') // when
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(UNAUTHORIZED_CODE);
          expect(res.body.message).toBe(UNAUTHORIZED_MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
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
