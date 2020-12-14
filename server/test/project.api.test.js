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

describe('get all projects', () => {
  it('project get all 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjects = seeder.projects.map(project => {
      const tasks = seeder.tasks.filter(
        task => project.creatorId === expectedUser.id && task.projectId === project.id,
      );
      const { id, title } = project;
      const defaultSectionId = seeder.sections.find(section => section.projectId === project.id);
      return { id, title, taskCount: tasks.length, defaultSectionId };
    });

    try {
      // when
      const res = await request(app)
        .get('/api/project')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);
      const recievedProjects = res.body.projectInfos;
      // then
      expect(
        recievedProjects.every(project =>
          expectedProjects.some(
            expectedProject =>
              Object.entries(project).toString === Object.entries(expectedProject).toString,
          ),
        ),
      ).toBeTruthy();
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('get project by id', () => {
  it('project get by id 일반', async done => {
    // given
    const expectedChildTaskId = seeder.tasks[3].id;
    const expectedProjectId = seeder.projects[0].id;
    const expectedUser = seeder.users[0];

    try {
      // when
      const res = await request(app)
        .get(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

      const childTask = res.body.project.sections[0].tasks[0].tasks[0];

      // then
      expect(childTask.id).toEqual(expectedChildTaskId);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('invalid id', async done => {
    // given
    const expectedProjectId = 'invalid id';
    const expectedUser = seeder.users[0];
    const expectedError = customError.INVALID_PARAM_ERROR('id');
    try {
      // when
      const res = await request(app)
        .get(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);
      const { message, code } = res.body;
      // then
      expect(res.status).toBe(expectedError.status);
      expect(message).toBe(expectedError.message);
      expect(code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('create project', () => {
  it('create project 일반', async done => {
    // given
    const requestBody = {
      title: '새 프로젝트',
      color: '#FFA7A7',
      isList: true,
    };
    const expectedUser = seeder.users[0];

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
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

describe('update project', () => {
  it('update project PUT', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'PUT으로 변경된 프로젝트',
      color: '#FFA7A7',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });

  it('update project PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'PATCH로 변경된 프로젝트!!',
    };

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
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

describe('delete project', () => {
  it('delete project 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    try {
      // when
      const res = await request(app)
        .delete(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

      // then
      expect(res.status).toBe(status.SUCCESS.CODE);
      expect(res.body.message).toBe(status.SUCCESS.MSG);
      done();
    } catch (err) {
      done(err);
    }
  });
});
