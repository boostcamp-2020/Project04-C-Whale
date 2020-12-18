require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
const { createJWT } = require('@utils/auth');
const { customError } = require('@utils/custom-error');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('get comments', () => {
  it('get comments 일반', async done => {
    // given
    const expectedComments = seeder.comments.sort((comment1, comment2) => {
      return comment1.createdAt.getTime() - comment2.createdAt.getTime();
    });

    const taskId = seeder.tasks[1].id;

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);
      const { comments } = res.body;
      // then
      expect(
        comments.every(recievedComment =>
          expectedComments.some(expectedComment => recievedComment.id === expectedComment.id),
        ),
      ).toBeTruthy();
      done();
    } catch (err) {
      done(err);
    }
  });
  it('comment가 없는 경우', async done => {
    // given
    const expectedComments = [];
    const taskId = seeder.tasks[0].id;

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);
      const { comments } = res.body;
      // then
      expect(comments).toStrictEqual(expectedComments);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('taskId가 잘못된 경우', async done => {
    // given
    const taskId = seeder.sections[1].id;
    const expectedError = customError.NOT_FOUND_ERROR('task');
    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 taskId가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const expectedError = customError.FORBIDDEN_ERROR();
    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('create comment', () => {
  it('create comment 일반', async done => {
    // given
    const requestBody = { content: '새로운 댓글' };
    const taskId = seeder.tasks[1].id;

    try {
      // when
      const res = await request(app)
        .post(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(status.SUCCESS.POST.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 content 생성', async done => {
    // given
    const requestBody = { content: '' };
    const taskId = seeder.tasks[1].id;
    const expectedError = customError.INVALID_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .post(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('data에 id 포함된 경우', async done => {
    // given
    const requestBody = { id: 'unnecessary id', content: '하이' };
    const taskId = seeder.tasks[1].id;
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .post(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('taskId가 잘못된 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.sections[1].id;
    const expectedError = customError.NOT_FOUND_ERROR('task');
    try {
      // when
      const res = await request(app)
        .post(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('taskId가 uuid가 아닌 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = 'invalid taskId';
    const expectedError = customError.INVALID_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .post(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 taskId가 아닌 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.tasks[0].id;
    const expectedError = customError.FORBIDDEN_ERROR();
    try {
      // when
      const res = await request(app)
        .post(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('update comment', () => {
  it('update comment 일반', async done => {
    // given
    const requestBody = { content: '바뀐 댓글' };
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);
      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('빈 배열 content', async done => {
    // given
    const requestBody = { content: '' };
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;
    const expectedError = customError.INVALID_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('data에 id가 포함된 경우', async done => {
    // given
    const requestBody = { id: seeder.comments[0].id, content: '하이하이' };
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('data에 taskId가 포함된 경우', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;
    const requestBody = { taskId, content: '하이하이' };
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('id가 없는 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('comment');
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('id가 uuid가 아닌 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.tasks[1].id;
    const commentId = 'invalidId';
    const expectedError = customError.INVALID_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('taskId가 없는 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.sections[1].id;
    const commentId = seeder.comments[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('task');
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('taskId가 uuid가 아닌 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = 'invalidId';
    const commentId = seeder.comments[0].id;
    const expectedError = customError.INVALID_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 commentId가 아닌 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.tasks[5].id;
    const commentId = seeder.comments[2].id;
    const expectedError = customError.FORBIDDEN_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 taskId가 아닌 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;
    const expectedError = customError.FORBIDDEN_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('task와 comment의 relation이 잘못된 경우', async done => {
    // given
    const requestBody = { content: '하이' };
    const taskId = seeder.tasks[0].id;
    const commentId = seeder.comments[0].id;
    const expectedError = customError.WRONG_RELATION_ERROR();
    try {
      // when
      const res = await request(app)
        .put(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('delete comment', () => {
  it('delete comment 일반', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;

    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('commentId가 uuid가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const commentId = 'invalid commentId';
    const expectedError = customError.INVALID_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('존재하지 않는 commentId', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('comment');

    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 comment가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[1].id;
    const expectedError = customError.FORBIDDEN_ERROR();

    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('task와 comment의 relation이 잘못된 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const commentId = seeder.comments[1].id;
    const expectedError = customError.WRONG_RELATION_ERROR();

    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}/comment/${commentId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.code).toBe(expectedError.code);
      expect(res.body.message).toBe(expectedError.message);
      done();
    } catch (err) {
      done(err);
    }
  });
});
