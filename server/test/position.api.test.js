require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
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

const getOrderedSections = expectedProjectId => {
  return seeder.sections
    .filter(section => section.projectId === expectedProjectId)
    .map(section => {
      const { id } = section;
      return id;
    })
    .sort((section1, section2) => section1.id - section2.id);
};

const getOrederedTasks = expectedSectionId => {
  return seeder.tasks
    .filter(task => task.sectionId === expectedSectionId)
    .map(task => {
      const { id } = task;
      return id;
    })
    .sort((task1, task2) => task1.id - task2.id);
};

describe('update project section positions', () => {
  it('update project section positions 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const orderedSections = getOrderedSections(expectedProjectId);
    const requestBody = { orderedSections };

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('sectionID가 잘못된 경우 포지션 patch', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const orderedSections = getOrderedSections(expectedProjectId);
    orderedSections.splice(0, 1, 'hi');
    const requestBody = { orderedSections };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('projectID가 잘못된 경우 포지션 patch', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = 'invalidId';
    const orderedSections = getOrderedSections(expectedProjectId);
    const requestBody = { orderedSections };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('자신의 project가 아닌 경우 포지션 patch', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[2].id;
    const orderedSections = getOrderedSections(expectedProjectId);
    const requestBody = { orderedSections };
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 project 포지션 patch', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.tasks[2].id;
    const orderedSections = getOrderedSections(expectedProjectId);
    const requestBody = { orderedSections };
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 sectionId가 포함된 patch', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const orderedSections = getOrderedSections(expectedProjectId);
    orderedSections.splice(0, 1, seeder.tasks[0].id);
    const requestBody = { orderedSections };
    const expectedError = customError.WRONG_RELATION_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
});

describe('update section task positions', () => {
  it('update section task positions 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const orderedTasks = getOrederedTasks(expectedSectionId);
    const requestBody = { orderedTasks };

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('taskId가 잘못된 경우 section task position 수정', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const orderedTasks = getOrederedTasks(expectedSectionId);
    orderedTasks.splice(0, 1, 'hi');
    const requestBody = { orderedTasks };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('projectID가 잘못된 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = 'invalidId';
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = {
      orderedTasks: [seeder.tasks[2].id, seeder.tasks[1].id, seeder.tasks[0].id],
    };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('sectionId 잘못된 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = 'invalidId';
    const requestBody = {
      orderedTasks: [seeder.tasks[2].id, seeder.tasks[1].id, seeder.tasks[0].id],
    };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('자신의 projectId가 아닌 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[2].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = {
      orderedTasks: [seeder.tasks[2].id, seeder.tasks[1].id, seeder.tasks[0].id],
    };
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 project인 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.sections[2].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = {
      orderedTasks: [seeder.tasks[2].id, seeder.tasks[1].id, seeder.tasks[0].id],
    };
    const expectedError = customError.NOT_FOUND_ERROR('project');

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 section 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[1].id;
    const requestBody = {
      orderedTasks: [seeder.tasks[2].id, seeder.tasks[1].id, seeder.tasks[0].id],
    };
    const expectedError = customError.NOT_FOUND_ERROR('section');

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 taskId가 포함된 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const orderedTasks = getOrederedTasks(expectedSectionId);
    orderedTasks.splice(0, 1, seeder.sections[2].id);
    const requestBody = { orderedTasks };
    const expectedError = customError.WRONG_RELATION_ERROR(
      'please check projectId, sectionId, tasks Id',
    );

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task/position`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
});
