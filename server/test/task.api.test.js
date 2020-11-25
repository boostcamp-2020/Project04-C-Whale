require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const { projects, tasks, labels, priorities, alarms } = require('@test/test-seed');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('get task by id', () => {
  it('get task by id 일반', done => {
    const expectedChildTaskId = '8d62f93c-9233-46a9-a5cf-ec18ad5a36f4';

    try {
      request(app)
        .get('/api/task/13502adf-83dd-4e8e-9acf-5c5a0abd5b1b')
        .end((err, res) => {
          if (err) {
            throw err;
          }

          const firstChildTaskId = res.body.tasks[0].id;
          expect(firstChildTaskId).toEqual(expectedChildTaskId);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});

describe('post task', () => {
  it('일반 task 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: projects[0].id,
      labelIdList: JSON.stringify(labels.map(label => label.id)),
      priorityId: priorities[0].id,
      dueDate: '2021-11-28',
      parentId: null,
      alarmId: alarms[0].id,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);
    expect(res.status).toBe(201);
    expect(res.body.message).toBe('ok');
    done();
  });

  it('project 없이 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: null,
      labelIdList: JSON.stringify(labels.map(label => label.id)),
      priorityId: priorities[0].id,
      dueDate: '2020-11-28',
      parentId: null,
      alarmId: alarms[0].id,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);

    expect(res.status).toBe(201);
    expect(res.body.message).toBe('ok');
    done();
  });

  it('label 없이 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: projects[0].id,
      labelIdList: JSON.stringify([]),
      priorityId: priorities[1].id,
      dueDate: '2020-11-28',
      parentId: null,
      alarmId: alarms[0].id,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);

    expect(res.status).toBe(201);
    expect(res.body.message).toBe('ok');
    done();
  });

  it('priority 없이 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: projects[0].id,
      labelIdList: JSON.stringify([]),
      priorityId: null,
      dueDate: '2020-11-28',
      parentId: null,
      alarmId: alarms[0].id,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);

    expect(res.status).toBe(201);
    expect(res.body.message).toBe('ok');
    done();
  });

  it('하위 할일 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: projects[1].id,
      labelIdList: JSON.stringify([]),
      priorityId: priorities[1].id,
      dueDate: '2020-11-28',
      parentId: tasks[0].id,
      alarmId: alarms[0].id,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);

    expect(res.status).toBe(201);
    expect(res.body.message).toBe('ok');
    done();
  });

  it('alarm 없이 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: projects[1].id,
      labelIdList: JSON.stringify([]),
      priorityId: priorities[1].id,
      dueDate: '2020-11-28',
      parentId: tasks[0].id,
      alarmId: null,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);

    expect(res.status).toBe(201);
    expect(res.body.message).toBe('ok');
    done();
  });

  it('alarm 없이 생성', async done => {
    // given
    const newTask = {
      title: '할일',
      projectId: projects[1].id,
      labelIdList: JSON.stringify([]),
      priorityId: priorities[1].id,
      dueDate: '2020-10-28',
      parentId: tasks[0].id,
      alarmId: null,
      position: 1,
    };

    const res = await request(app).post('/api/task').send(newTask);

    expect(res.status).toBe(400);
    expect(res.body.message).toBe('유효하지 않은 dueDate');
    done();
  });
});
