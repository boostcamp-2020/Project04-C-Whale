require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');
const status = require('@test/response-status');
const { customError } = require('@utils/custom-error');
const { createJWT } = require('@utils/auth');

describe('create section', () => {
  it('create project 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: '새로운 섹션',
    };

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
});

describe('update section task positions', () => {
  it('update section task positions 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;
    const requestBody = {
      orderedTasks: [seeder.tasks[2].id, seeder.tasks[1].id, seeder.tasks[0].id],
    };

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
});

describe('delete section', () => {
  it('update section 일반', async done => {
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
});
