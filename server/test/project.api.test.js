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
  it('프로젝트가 없는 유저', async done => {
    // given
    const expectedUser = seeder.users[2];
    const expectedProjects = [];

    try {
      // when
      const res = await request(app)
        .get('/api/project')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);
      const recievedProjects = res.body.projectInfos;
      // then
      expect(recievedProjects).toStrictEqual(expectedProjects);
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
  it('잘못된 타입의 projectId로 조회', async done => {
    // given
    const expectedProjectId = 77;
    const expectedUser = seeder.users[0];
    const expectedError = customError.INVALID_INPUT_ERROR();
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
  it('잘못된 id로 조회', async done => {
    // given
    const expectedProjectId = 'invalid id';
    const expectedUser = seeder.users[0];
    const expectedError = customError.INVALID_INPUT_ERROR();
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
  it('존재하지 않는 id로 조회', async done => {
    // given
    const expectedProjectId = seeder.sections[0].id;
    const expectedUser = seeder.users[0];
    const expectedError = customError.NOT_FOUND_ERROR();
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
  it('자신의 project가 아닌 조회', async done => {
    // given
    const expectedProjectId = seeder.projects[2].id;
    const expectedUser = seeder.users[0];
    const expectedError = customError.FORBIDDEN_ERROR();
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
      isFavorite: true,
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
  it('id가 포함된 project 생성', async done => {
    // given
    const requestBody = {
      id: 'UNNECESSARY ID',
      title: '새 프로젝트',
      color: '#FFA7A7',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.UNNECESSARY_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('빈 문자열 title 생성', async done => {
    // given
    const requestBody = {
      title: '',
      color: '#FFA7A7',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.INVALID_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 타입 title 생성', async done => {
    // given
    const requestBody = {
      title: 77,
      color: '#FFA7A7',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('빈 문자열 color 생성', async done => {
    // given
    const requestBody = {
      title: 'hi',
      color: '',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.INVALID_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 타입의 color 생성', async done => {
    // given
    const requestBody = {
      title: 'hi',
      color: 77,
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 isList 타입 생성', async done => {
    // given
    const requestBody = {
      title: 'hhi',
      color: '#FFA7A7',
      isList: 'hi',
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.TYPE_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 isFavorite 타입 생성', async done => {
    // given
    const requestBody = {
      title: 'hhi',
      color: '#FFA7A7',
      isList: true,
      isFavorite: 'hi',
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.TYPE_ERROR();

    try {
      // when
      const res = await request(app)
        .post('/api/project/')
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
});

describe('update PUT project', () => {
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
  it('title이 누락된 PUT 요청', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      color: '#FFA7A7',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('color가 누락된 PUT 요청', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'hi',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('title이 누락된 PUT 요청', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      color: '#123456',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('isList가 누락된 PUT 요청', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'hi',
      color: '#123456',
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.TYPE_ERROR();

    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('isFavorite이 누락된 PUT 요청', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'hi',
      color: '#123456',
      isList: true,
    };
    const expectedUser = seeder.users[0];
    const expectedError = customError.TYPE_ERROR();

    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('전체가 누락된 PUT 요청', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {};
    const expectedUser = seeder.users[0];
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .put(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
});
describe('update PATCH project', () => {
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
  it('title 빈 문자열 PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { title: '' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 타입의 title PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { title: 77 };
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('color 빈 문자열 PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { color: '' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('color 일반 평문 문자열 PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { color: 'invalid color' };
    const expectedError = customError.INVALID_INPUT_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 타입의 color PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { color: 77 };
    const expectedError = customError.MULTIPLE_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 타입의 isList PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { isList: 'hi' };
    const expectedError = customError.TYPE_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('잘못된 타입의 isFavorite PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = { isFavorite: 'hi' };
    const expectedError = customError.TYPE_ERROR();

    try {
      // when
      const res = await request(app)
        .patch(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
        .send(requestBody);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
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
  it('잘못된 project ID로 삭제', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = 'invalidId';
    const expectedError = customError.INVALID_INPUT_ERROR();
    try {
      // when
      const res = await request(app)
        .delete(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('존재하지 않는 project ID로 삭제', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.sections[0].id;
    const expectedError = customError.NOT_FOUND_ERROR();
    try {
      // when
      const res = await request(app)
        .delete(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
  it('자신의 프로젝트가 아닌 삭제 요청', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[2];
    const expectedError = customError.FORBIDDEN_ERROR();
    try {
      // when
      const res = await request(app)
        .delete(`/api/project/${expectedProjectId}`)
        .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

      // then
      expect(res.status).toBe(expectedError.status);
      expect(res.body.message).toBe(expectedError.message);
      expect(res.body.code).toBe(expectedError.code);
      done();
    } catch (err) {
      done(err);
    }
  });
});
