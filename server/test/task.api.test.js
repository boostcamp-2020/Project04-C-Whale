require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
const { createJWT } = require('@utils/auth');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('get All task', () => {
  it('성공 조건', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedTasks = seeder.tasks
      .filter(task => {
        const projects = seeder.projects.filter(project => project.creatorId === expectedUser.id);
        return projects.some(project => project.id === task.projectId);
      })
      .map(task => {
        const { id, title } = task;
        return { id, title };
      });
    try {
      // when
      const res = await request(app)
        .get('/api/task')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

      const { tasks } = res.body;
      // then
      expect(
        tasks.every(task =>
          expectedTasks.some(
            expectedTask =>
              Object.entries(expectedTask).toString() === Object.entries(task).toString(),
          ),
        ),
      ).toBeTruthy();
      // expect(tasks).toStrictEqual(expectedTasks);
      done();
    } catch (err) {
      done(err);
    }
  });

  it('task가 없는 유저', async done => {
    // given
    const expectedTasks = [];
    try {
      // when
      const res = await request(app)
        .get('/api/task')
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`);

      const { tasks } = res.body;
      // then
      expect(tasks).toStrictEqual(expectedTasks);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('get task by id', () => {
  it('get task by id 일반', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const expectedChildren = seeder.tasks.filter(task => task.parentId === taskId);

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      const recievedChildren = res.body.tasks.filter(task => task.parentId === taskId);

      // then
      recievedChildren.forEach(recievedChild => {
        expect(
          expectedChildren.some(expectedChild => recievedChild.id === expectedChild.id),
        ).toBeTruthy();
      });

      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('patch task with id', () => {
  it('patch task with id 일반', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: seeder.projects[0].id,
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    try {
      // when
      const res = await request(app)
        .patch(`/api/task/${seeder.tasks[1].id}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(newTask);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });

  it('patch task without labels', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: seeder.projects[0].id,
      labelIdList: JSON.stringify([]),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    try {
      // when
      const res = await request(app)
        .patch(`/api/task/${seeder.tasks[2].id}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(newTask);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('delete task', () => {
  it('delete task 일반', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('get comments', () => {
  it('get comments 일반', async done => {
    // given
    const expectedCommentId = seeder.comments[0].id;
    const taskId = seeder.tasks[1].id;

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}/comment`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);
      const firstCommentId = res.body[0].id;

      // then
      expect(firstCommentId).toEqual(expectedCommentId);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('create comment', () => {
  it('create comment 일반', async done => {
    // given
    const requestBody = {
      content: '새로운 댓글',
    };
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
});

describe('update comment', () => {
  it('update comment 일반', async done => {
    // given
    const requestBody = {
      content: '바뀐 댓글',
    };
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
});

describe('delete comment', () => {
  it('delete comment 일반', async done => {
    // given
    const requestBody = {
      content: '바뀐 댓글',
    };
    const taskId = seeder.tasks[1].id;
    const commentId = seeder.comments[0].id;

    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}/comment/${commentId}`)
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
});
