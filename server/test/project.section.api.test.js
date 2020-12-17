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

describe('create section', () => {
  it('create section 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { title: '새로운 섹션' };

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('타이틀 빈 문자열 생성', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { title: '' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('타이틀 없이 생성', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {};
    const expectedError = customError.MULTIPLE_ERROR();

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('타입이 잘못된 타이틀 생성', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { title: 77 };
    const expectedError = customError.MULTIPLE_ERROR();

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('id가 포함된 생성', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { id: 'invalidId', title: '하이' };
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('projectId가 UUID가 아닌 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = 'invalidId';
    const requestBody = { title: '새로운 섹션' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('자신의 project가 아닌 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[2].id;
    const requestBody = { title: '새로운 섹션' };
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('없는 project인 경우', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.sections[2].id;
    const requestBody = { title: '새로운 섹션' };
    const expectedError = customError.NOT_FOUND_ERROR('project');

    // when
    const res = await request(app)
      .post(`/api/project/${expectedProjectId}/section`)
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
    const orderedTasks = seeder.tasks
      .filter(task => task.sectionId === expectedSectionId)
      .map(task => {
        const { id, ...others } = task;
        return id;
      })
      .sort((task1, task2) => task1.id - task2.id);

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
  it('taskId가 잘못된 경우 sectino task position 수정', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = { orderedTasks: ['hi', seeder.tasks[1].id, seeder.tasks[0].id] };
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
    const orderedTasks = seeder.tasks
      .filter(task => task.sectionId === expectedSectionId)
      .map(task => {
        const { id, ...others } = task;
        return id;
      })
      .sort((task1, task2) => task1.id - task2.id);
    orderedTasks[0] = seeder.sections[2].id;
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

describe('update section', () => {
  it('update section 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = {
      title: '바뀐 섹션',
    };

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('빈 title로 update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = { title: '' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('타입이 잘못된 title로 update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = { title: { hi: 3 } };
    const expectedError = customError.MULTIPLE_ERROR();

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('잘못된 projectId update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = 'invalidId';
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = { title: 'asd' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('잘못된 sectionId update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = 'invalidId';
    const requestBody = { title: 'asd' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('자신의 project가 아닌 update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[2].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = { title: 'asd' };
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 project update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.sections[1].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = { title: 'asd' };
    const expectedError = customError.NOT_FOUND_ERROR('project');

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 section update 시도', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.projects[1].id;
    const requestBody = { title: 'hi' };
    const expectedError = customError.NOT_FOUND_ERROR('section');

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
});

describe('delete section', () => {
  it('delete section 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    const expectedSectionId = seeder.sections[1].id;

    // when
    const res = await request(app)
      .delete(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
  it('자신의 섹션이 아닌 경우 delete', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    const expectedSectionId = seeder.sections[2].id;
    const expectedError = customError.FORBIDDEN_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('잘못된 sectionId로 delete', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    const expectedSectionId = 'invalidId';
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('타입이 잘못된 sectionId delete', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    const expectedSectionId = { hi: 'hi' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    // when
    const res = await request(app)
      .delete(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
  it('존재하지 않는 sectionId delete', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    const expectedSectionId = seeder.projects[1].id;
    const expectedError = customError.NOT_FOUND_ERROR('section');

    // when
    const res = await request(app)
      .delete(`/api/project/${expectedProjectId}/section/${expectedSectionId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    // then
    expect(res.status).toBe(expectedError.status);
    expect(res.body.code).toBe(expectedError.code);
    expect(res.body.message).toBe(expectedError.message);
    done();
  });
});
