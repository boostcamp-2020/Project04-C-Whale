require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
const { createJWT } = require('@utils/auth');
const errorMessage = require('@models/dto/error-messages');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('post task', () => {
  it('성공하는 task 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });

  it('label 없이 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify([]),
      priorityId: seeder.priorities[1].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });

  it('priority 없이 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify([]),
      priorityId: null,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });

  it('하위 할일 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify([]),
      priorityId: seeder.priorities[1].id,
      dueDate: new Date(),
      parentId: seeder.tasks[0].id,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });

  it('alarm 없이 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify([]),
      priorityId: seeder.priorities[1].id,
      dueDate: new Date(),
      parentId: seeder.tasks[0].id,
      alarmId: null,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });

  it('유효하지 않은 duedate 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      projectId: seeder.projects[1].id,
      labelIdList: JSON.stringify([]),
      priorityId: seeder.priorities[1].id,
      dueDate: '2020-10-28',
      parentId: seeder.tasks[0].id,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.DUEDATE_ERROR);
    done();
  });

  it('잘못된 projectId 생성', async done => {
    // given
    const expectedProjectId = 'wrongId';
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('projectId'));
    done();
  });
  it('잘못된 sectionId 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = 'wrongId';
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('sectionId'));
    done();
  });
  it('잘못된 parentId 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedParentId = 'wrongId';
    const newTask = {
      title: '할일',
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: expectedParentId,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('parentId'));
    done();
  });
  it('작업 id가 포함된 생성', async done => {
    // given
    const expectedId = seeder.projects[1].id;
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      id: expectedId,
      title: '할일',
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.UNNECESSARY_INPUT_ERROR('id'));
    done();
  });
  it('빈 문자열 title 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '',
      labelIdList: JSON.stringify(seeder.labels.map(label => label.id)),
      priorityId: seeder.priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      alarmId: seeder.alarms[0].id,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(status.BAD_REQUEST.CODE);
    expect(res.body.message).toBe(errorMessage.INVALID_INPUT_ERROR('title'));
    done();
  });
});
