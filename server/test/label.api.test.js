require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const { createJWT } = require('@utils/auth');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

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
          expect(res.status).toBe(status.SUCCESS.CODE);
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
          expect(res.status).toBe(status.UNAUTHORIZED.CODE);
          expect(res.body.message).toBe(status.UNAUTHORIZED.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 생성 API (with Authorization)', done => {
    // given
    const expectedLabel = {
      title: 'BE',
      color: '#FFFFFF',
    };

    try {
      request(app)
        .post('/api/label') // when
        .set('Authorization', createJWT(seeder.users[0]))
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          expect(res.status).toBe(status.SUCCESS.POST.CODE);
          expect(res.body.message).toBe(status.SUCCESS.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 생성 API (token X)', done => {
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
          // then
          expect(res.status).toBe(status.UNAUTHORIZED.CODE);
          expect(res.body.message).toBe(status.UNAUTHORIZED.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 생성 API (title X)', done => {
    // given
    const expectedLabel = {
      color: '#FFFFFF',
    };

    try {
      request(app)
        .post('/api/label') // when
        .set('Authorization', createJWT(seeder.users[0]))
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.BAD_REQUEST.CODE);
          expect(res.body.message).toBe(status.BAD_REQUEST.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 생성 API (color X)', done => {
    // given
    const expectedLabel = {
      color: '#FFFFFF',
    };

    try {
      request(app)
        .post('/api/label') // when
        .set('Authorization', createJWT(seeder.users[0]))
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.BAD_REQUEST.CODE);
          expect(res.body.message).toBe(status.BAD_REQUEST.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
