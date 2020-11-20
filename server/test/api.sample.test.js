require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');

// describe('login API test', () => {
//   //   const NAVER_URL = 'api/user/oauth/naver';
//   const NAVER_URL = '/';
//   it('token check', done => {
//     // given
//     const expectedToken = 'Bearer tokenString';
//     const expectedStatus = 200;
//     const expectedMSG = 'ok';

//     try {
//       request(app)
//         .get(NAVER_URL) // when
//         .end((err, res) => {
//           if (err) {
//             throw err;
//           }
//           const { token, message } = res.body;
//           const { status } = res.headers;
//           // then
//           expect(status).toBe(expectedStatus);
//           expect(token).toBe(expectedToken);
//           expect(message).toBe(expectedMSG);
//           done();
//         });
//     } catch (err) {
//       done(err);
//     }
//   });
// });
// app.on('TEST_READY', (app)=> {

// })
describe('user api', () => {
  it('label get all', done => {
    // given
    const expectedMSG = JSON.stringify([
      {
        email: 'kyle@example.com',
        name: 'kyle',
        provider: 'naver',
        createdAt: '2020-11-20T06:04:55.000Z',
        updatedAt: '2020-11-20T06:04:55.000Z',
      },
    ]);

    try {
      request(app)
        .get('/label') // when
        .end((err, res) => {
          if (err) {
            throw err;
          }

          const result = JSON.stringify(res.body);
          console.log(result);

          expect(result).toBe(expectedMSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });

  it('user get all', done => {
    // given
    const expectedMSG = JSON.stringify([
      {
        email: 'kyle@example.com',
        name: 'kyle',
        provider: 'naver',
        createdAt: '2020-11-20T06:04:55.000Z',
        updatedAt: '2020-11-20T06:04:55.000Z',
      },
    ]);

    try {
      request(app)
        .get('/user') // when
        .end((err, res) => {
          if (err) {
            throw err;
          }

          const result = JSON.stringify(res.body);

          expect(result).toBe(expectedMSG);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
