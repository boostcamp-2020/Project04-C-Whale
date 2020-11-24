require('module-alias/register');
const request = require('supertest');
const app = require('@root/app');
const seeder = require('@test/test-seed');

beforeAll(async done => {
  await seeder.up();
  done();
});

afterAll(async done => {
  await seeder.down();
  done();
});

describe('get all projects', () => {
  it('project get all 일반', done => {
    // given
    const expectedProjects = [
      { id: 'b7f253e5-7b6b-4ee2-b94e-369ffcdffb5f', taskCount: 3, title: '프로젝트 1' },
      { id: 'f7605077-96ec-4365-88fc-a9c3af4a084e', taskCount: 0, title: '프로젝트 2' },
      { taskCount: 2, title: '오늘' },
    ];

    try {
      request(app)
        .get('/api/project') // when
        .end((err, res) => {
          if (err) {
            throw err;
          }

          expect(res.body).toEqual(expectedProjects);
          done();
        });
    } catch (err) {
      done(err);
    }
  });
});
