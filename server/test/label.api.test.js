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
    const expectedLabels = seeder.labels
      .filter(label => label.id === seeder.labels[0].id)
      .map(label => {
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
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
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
  it('label 생성 API (token O)', done => {
    // given
    const expectedLabel = {
      title: 'BE',
      color: '#FFFFFF',
    };

    try {
      request(app)
        .post('/api/label') // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
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
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
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
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
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

  it('label 수정 API (token O)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .put(`/api/label/${seeder.labels[0].id}`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.SUCCESS.CODE);
          expect(res.body.message).toBe(status.SUCCESS.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 수정 API (token X)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .put(`/api/label/${seeder.labels[0].id}`) // when
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
  it('label 수정 API (잘못된 요청의 데이터)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: 500,
    };

    try {
      request(app)
        .put(`/api/label/${seeder.labels[0].id}`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
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
  it('label 수정 API (자신의 label이 아닌 경우)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .put(`/api/label/${seeder.labels[0].id}`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.FORBIDDEN.CODE);
          expect(res.body.message).toBe(status.FORBIDDEN.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 수정 API (존재하지 않는 label ID)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .put(`/api/label/nothing`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.NOT_FOUND.CODE);
          expect(res.body.message).toBe(status.NOT_FOUND.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });

  it('label 삭제 API (자신의 label이 아닌 경우))', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .delete(`/api/label/${seeder.labels[1].id}`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.FORBIDDEN.CODE);
          expect(res.body.message).toBe(status.FORBIDDEN.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 삭제 API (존재하지 않는 label ID)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .delete(`/api/label/nothing`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.NOT_FOUND.CODE);
          expect(res.body.message).toBe(status.NOT_FOUND.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 삭제 API (token O)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .delete(`/api/label/${seeder.labels[1].id}`) // when
        .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
        .send(expectedLabel)
        .end((err, res) => {
          if (err) {
            throw err;
          }
          // then
          expect(res.status).toBe(status.SUCCESS.CODE);
          expect(res.body.message).toBe(status.SUCCESS.MSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
  it('label 삭제 API (token X)', done => {
    // given
    const expectedLabel = {
      title: '크리스탈',
      color: '#FFE3CD',
    };

    try {
      request(app)
        .delete(`/api/label/${seeder.labels[1].id}`) // when
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
});
