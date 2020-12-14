require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const { customError } = require('@utils/custom-error');
const { createJWT } = require('@utils/auth');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('get bookmark', () => {
  it('bookmark 조회 성공', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const expectedBookmarks = seeder.bookmarks.map(bookmark => {
      const copy = { ...bookmark };
      delete copy.createdAt;
      delete copy.deletedAt;
      delete copy.taskId;
      return copy;
    });

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0].id)}`);

    const { bookmarks } = res.body;

    // then
    bookmarks
      .every(recievedBookmark => {
        return expectedBookmarks.some(
          expectedBookmark =>
            Object.entries(recievedBookmark).toString === Object.entries(expectedBookmark).toString,
        );
      })
      .toBeTruthy();
    done();
  });
  it('bookmark 조회 성공', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const expectedBookmarks = [];

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0].id)}`);

    const { bookmarks } = res.body;

    // then
    bookmarks.toStrictEqual(expectedBookmarks);
    done();
  });
  it('taskId가 uuid가 아닌 경우', async done => {
    // given
    const taskId = 'invalid taskId';
    const expectedError = customError.INVALID_INPUT_ERROR('taskId');

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0].id)}`);

    // then
    expectedError(res.status).toBe(expectedError.status);
    expectedError(res.body.message).toBe(expectedError.message);
    expectedError(res.body.code).toBe(expectedError.code);
    done();
  });
  it('taskId가 없는 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('task');

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0].id)}`);

    // then
    expectedError(res.status).toBe(expectedError.status);
    expectedError(res.body.message).toBe(expectedError.message);
    expectedError(res.body.code).toBe(expectedError.code);
    done();
  });
  it('자신의 taskId가 아닌 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;
    const expectedError = customError.FORBIDDEN_ERROR('task');

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[2].id)}`);

    // then
    expectedError(res.status).toBe(expectedError.status);
    expectedError(res.body.message).toBe(expectedError.message);
    expectedError(res.body.code).toBe(expectedError.code);
    done();
  });
});

// describe('post bookmark', () => {
//   it('bookmark 생성 성공', async done => {
//     // given
//     const taskId = seeder.tasks[0].id;
//     const data = { url: 'https://www.naver.com', title: '네이버' };

//     // when
//     const res = request(app)
//       .post(`/api/task/${taskId}/bookmark`)
//       .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
//       .send(data);

//     // then

//   });
// });

// describe('delete bookmark', () => {
//   it('bookmark 삭제 성공', async done => {
//     // given
//     // when
//     // then
//   });
// });
