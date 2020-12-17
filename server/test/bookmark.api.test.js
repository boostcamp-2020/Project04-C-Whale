require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const status = require('@test/response-status');
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
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    const { bookmarks } = res.body;

    // then
    expect(
      bookmarks.every(recievedBookmark => {
        return expectedBookmarks.some(
          expectedBookmark =>
            Object.entries(recievedBookmark).toString === Object.entries(expectedBookmark).toString,
        );
      }),
    ).toBeTruthy();
    done();
  });
  it('bookmark 조회 성공', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const expectedBookmarks = [];

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    const { bookmarks } = res.body;

    // then
    expect(bookmarks).toStrictEqual(expectedBookmarks);
    done();
  });
  it('taskId가 uuid가 아닌 경우', async done => {
    // given
    const taskId = 'invalid taskId';
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('taskId가 없는 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('task');

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('자신의 taskId가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .get(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
});

describe('post bookmark', () => {
  it('bookmark 생성 성공', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { url: 'https://www.naver.com', title: '네이버' };

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('title 없이 생성', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { url: 'https://www.naver.com' };

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('request에 id가 포함된 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { id: 'hi', url: 'https://www.naver.com', title: '네이버' };
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('request에 taskId가 포함된 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { taskId, url: 'https://www.naver.com', title: '네이버' };
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('url 형식이 잘못된 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { url: '배고프다' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('url이 없는 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { title: '네이버 웨일로 가봅시다!' };
    const expectedError = customError.NECESSARY_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('빈 title로 생성하려는 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { url: 'https://www.naver.com', title: '' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('taskId가 uuid가 아닌 경우', async done => {
    // given
    const taskId = 'invalid taskId';
    const data = { url: 'https://www.naver.com', title: '네이버' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('task가 존재하지 않는 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;
    const data = { url: 'https://www.naver.com', title: '네이버' };
    const expectedError = customError.NOT_FOUND_ERROR('task');

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('자신의 task가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const data = { url: 'https://www.naver.com', title: 'hi' };
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .post(`/api/task/${taskId}/bookmark`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`)
      .send(data);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
});

describe('delete bookmark', () => {
  it('bookmark 삭제 성공', async done => {
    // given
    const taskId = seeder.tasks[2].id;
    const bookmarkId = seeder.bookmarks[1].id;
    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('taskId가 잘못된 Id인 경우', async done => {
    // given
    const taskId = 'Invalid taskId';
    const bookmarkId = seeder.bookmarks[0].id;
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('bookmarkId가 잘못된 Id인 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const bookmarkId = 'invalid bookmarkId';
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('존재하지 않는 taskId인 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;
    const bookmarkId = seeder.bookmarks[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('task');

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('존재하지 않는 bookmarkId인 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const bookmarkId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('bookmark');

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('자신의 task가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const bookmarkId = seeder.bookmarks[2].id;
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('자신의 bookmark가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const bookmarkId = seeder.bookmarks[2].id;
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
  it('task랑 bookmark가 관계가 잘못된 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const bookmarkId = seeder.bookmarks[3].id;
    const expectedError = customError.WRONG_RELATION_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/task/${taskId}/bookmark/${bookmarkId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.message).toBe(expectedError.message);
    expect(res.body.code).toBe(expectedError.code);
    done();
  });
});
