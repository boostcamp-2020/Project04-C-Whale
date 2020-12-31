require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
const { createJWT } = require('@utils/auth');
const { customError } = require('../src/utils/custom-error');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

const priorities = ['1', '2', '3', '4'];

describe('post task', () => {
  it('성공하는 task 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const newTask = {
      title: '할일',
      priority: priorities[0],
      dueDate: new Date(),
      parent: null,
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
      priority: null,
      dueDate: new Date(),
      parentId: null,
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
      priority: priorities[1],
      dueDate: new Date(),
      parentId: seeder.tasks[0].id,
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
    const expectedError = customError.DUEDATE_ERROR();

    const newTask = {
      title: '할일',
      projectId: seeder.projects[1].id,
      priority: priorities[1].id,
      dueDate: '2020-10-28',
      parentId: seeder.tasks[0].id,
      position: 1,
    };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });

  it('duedate를 내년으로 설정', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;

    const newTask = {
      title: '할일',
      projectId: seeder.projects[1].id,
      priority: priorities[1].id,
      dueDate: new Date('2021-1-1'),
      parentId: seeder.tasks[0].id,
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

  it('duedate를 다음달로 설정', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;

    const newTask = {
      title: '할일',
      projectId: seeder.projects[1].id,
      priority: priorities[1].id,
      dueDate: new Date('2021-2-1'),
      parentId: seeder.tasks[0].id,
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

  it('잘못된 parentId 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedParentId = 'wrongId';
    const expectedError = customError.INVALID_INPUT_ERROR();
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: expectedParentId,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('작업 id가 포함된 생성', async done => {
    // given
    const expectedId = seeder.projects[1].id;
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    const newTask = {
      id: expectedId,
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('섹션 id가 포함된 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();
    const newTask = {
      title: '할일',
      sectionId: expectedSectionId,
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('빈 문자열 title 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.INVALID_INPUT_ERROR();
    const newTask = {
      title: '',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('잘못된 값의 projectId 생성', async done => {
    // given
    const expectedProjectId = 'wrongId';
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.INVALID_INPUT_ERROR();
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('잘못된 값의 sectionId 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = 'Invalid sectionId';
    const expectedError = customError.INVALID_INPUT_ERROR();
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 projectId 생성', async done => {
    // given
    const expectedProjectId = seeder.tasks[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('project');
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 sectionId 생성', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.tasks[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('section');
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('자신의 프로젝트가 아닌 경우', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.FORBIDDEN_ERROR();
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('자신의 섹션 아닌 경우 (NOT FOUND)', async done => {
    // given
    const expectedProjectId = seeder.projects[2].id;
    const expectedSectionId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR('section');
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[1])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('잘못된 관계의 프로젝트와 섹션의 경우 (NOT FOUND)', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[1].id;
    const expectedError = customError.NOT_FOUND_ERROR('section');
    const newTask = {
      title: '할일',
      priority: priorities[0].id,
      dueDate: new Date(),
      parentId: null,
      position: 1,
    };
    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
      .set('Authorization', `Bearer ${createJWT(seeder.users[0])}`)
      .send(newTask);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
});
