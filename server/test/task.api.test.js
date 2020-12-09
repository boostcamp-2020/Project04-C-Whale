require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
const { createJWT } = require('@utils/auth');
const errorMessage = require('@utils/error-messages');

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
        tasks.every(task => expectedTasks.some(expectedTask => expectedTask.id === task.id)),
      ).toBeTruthy();
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
  it('토큰 값이 없는 경우 ', async done => {
    // given
    try {
      // when
      const res = await request(app).get('/api/task');

      // then
      expect(res.status).toBe(status.UNAUTHORIZED.CODE);
      expect(res.body.message).toBe(status.UNAUTHORIZED.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('get task by id', () => {
  it('get task by id 성공', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const expectedChildren = seeder.tasks.filter(task => task.parentId === taskId);

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      const recievedChildren = res.body.task.tasks.filter(
        childTask => childTask.parentId === taskId,
      );

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
  it('잘못된 id 값 요청', async done => {
    // given
    const taskId = 'invalidId';

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(status.BAD_REQUEST.CODE);
      expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('id'));
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 task id가 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`);

      // then
      expect(res.status).toBe(status.FORBIDDEN.CODE);
      expect(res.body.message).toBe(status.FORBIDDEN.MSG);

      done();
    } catch (err) {
      done(err);
    }
  });
  it('존재하지 않는 task id인 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;

    try {
      // when
      const res = await request(app)
        .get(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(status.NOT_FOUND.CODE);
      expect(res.body.message).toBe(errorMessage.NOT_FOUND_ERROR('task'));

      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('patch task with id', () => {
  it('patch task with id 성공', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = {
      title: '할일',
      projectId: seeder.projects[0].id,
      sectionId: seeder.sections[0].id,
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    try {
      // when
      const res = await request(app)
        .patch(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(patchTask);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('isDone 성공', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { isDone: true };

    try {
      // when
      const res = await request(app)
        .patch(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
        .send(patchTask);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });

  it('id값이 포함된 수정', async done => {
    // given
    const patchTask = { id: seeder.tasks[0].id, title: '졸리다' };

    // when
    const res = await request(app)
      .patch(`/api/task/${patchTask.id}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.UNNECESSARY_INPUT_ERROR('id'));
    done();
  });
  it('잘못된 title 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { title: '' };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('title'));
    done();
  });

  it('잘못된 parentId 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { parentId: 'invalidId' };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('parentId'));
    done();
  });

  it('잘못된 projectId 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { projectId: 'invalidId' };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('projectId'));
    done();
  });
  it('잘못된 priorityId 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { priorityId: 'invalidId' };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('priorityId'));
    done();
  });
  it('잘못된 alarmId 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { alarmId: 'invalidId' };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('alarmId'));
    done();
  });
  it('잘못된 isDone 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { isDone: 'hi' };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.TYPE_ERROR('isDone'));
    done();
  });
  it('잘못된 duedate 수정', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { duedate: new Date('2020-11-11') };

    // when
    const res = await request(app)
      .patch(`/api/task/${taskId}`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(patchTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.DUEDATE_ERROR);
    done();
  });
  it('자신의 작업이 아닌 경우', async done => {
    // given
    const taskId = seeder.tasks[0].id;
    const patchTask = { isDone: true };

    try {
      // when
      const res = await request(app)
        .patch(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`)
        .send(patchTask);

      // then
      expect(res.status).toBe(status.FORBIDDEN.CODE);
      expect(res.body.message).toBe(status.FORBIDDEN.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('존재하지 않는 작업인 경우', async done => {
    // given
    const taskId = seeder.sections[0].id;
    const patchTask = { isDone: true };

    try {
      // when
      const res = await request(app)
        .patch(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[2])}`)
        .send(patchTask);

      // then
      expect(res.status).toBe(status.NOT_FOUND.CODE);
      expect(res.body.message).toBe(errorMessage.NOT_FOUND_ERROR('task'));
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
  it('없는 id', async done => {
    // given
    const taskId = seeder.sections[0].id;
    try {
      // when
      const res = await request(app)
        .delete(`/api/task/${taskId}`)
        .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`);

      // then
      expect(res.status).toBe(status.BAD_REQUEST.CODE);
      expect(res.body.message).toBe(errorMessage.BAD_REQUEST_ERROR('id'));
      done();
    } catch (err) {
      done(err);
    }
  });
});
