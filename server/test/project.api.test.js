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

describe('get all projects', () => {
  it('project get all 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjects = seeder.projects.map(project => {
      const tasks = seeder.tasks.filter(
        task => project.creatorId === expectedUser.id && task.projectId === project.id,
      );
      const { id, title } = project;
      return { id, title, taskCount: tasks.length };
    });

    // when
    const res = await request(app)
      .get('/api/project')
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);
    const recievedProjects = res.body;

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
  });
});

describe('get project by id', () => {
  it('project get by id 일반', async done => {
    // given
    const expectedChildTaskId = seeder.tasks[3].id;
    const expectedProjectId = seeder.projects[0].id;
    const expectedUser = seeder.users[0];

    // when
    const res = await request(app)
      .get(`/api/project/${expectedProjectId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    const childTask = res.body.sections[0].tasks[0].tasks[0];

    // then
    expect(childTask.id).toEqual(expectedChildTaskId);
    done();
  });
});

describe('create project', () => {
  it('create project 일반', async done => {
    // given
    const requestBody = {
      title: '새 프로젝트',
      isList: true,
    };
    const expectedUser = seeder.users[0];

    // when
    const res = await request(app)
      .post('/api/project/')
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.POST.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
});

describe('update project', () => {
  it('update project PUT', async done => {
    // given
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'PUT으로 변경된 프로젝트',
      isList: true,
      isFavorite: true,
    };
    const expectedUser = seeder.users[0];

    // when
    const res = await request(app)
      .put(`/api/project/${expectedProjectId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });

  it('update project PATCH', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[0].id;
    const requestBody = {
      title: 'PATCH로 변경된 프로젝트!!',
    };

    // when
    const res = await request(app)
      .patch(`/api/project/${expectedProjectId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`)
      .send(requestBody);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
});

describe('delete project', () => {
  it('delete project 일반', async done => {
    // given
    const expectedUser = seeder.users[0];
    const expectedProjectId = seeder.projects[1].id;
    // when
    const res = await request(app)
      .delete(`/api/project/${expectedProjectId}`)
      .set('Authorization', `Bearer ${createJWT(expectedUser)}`);

    // then
    expect(res.status).toBe(status.SUCCESS.CODE);
    expect(res.body.message).toBe(status.SUCCESS.MSG);
    done();
  });
});

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
      .post(`/api/project/${expectedProjectId}/section/${expectedSectionId}/task`)
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
    const expectedProjectId = seeder.projects[0].id;
    const expectedSectionId = seeder.sections[0].id;

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
