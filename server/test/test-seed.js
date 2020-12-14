const sequelize = require('@models');

const users = [
  {
    id: 'ff4dd832-1567-4d74-b41d-bd85e96ce329',
    email: 'email@example.com',
    name: 'tony',
    provider: 'naver',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'd0325b52-b8d2-4623-b537-79b0d01cee1d',
    email: 'zin0@naver.com',
    name: 'zin0',
    provider: 'naver',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'c83abea3-bc93-44a4-b56c-dda6c742a94d',
    email: 'kyle@naver.com',
    name: 'kyle',
    provider: 'naver',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const projects = [
  {
    id: 'b7f253e5-7b6b-4ee2-b94e-369ffcdffb5f',
    creatorId: users[0].id,
    title: '프로젝트 1',
    color: '#FFA7A7',
    isList: true,
    isFavorite: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'f7605077-96ec-4365-88fc-a9c3af4a084e',
    creatorId: users[0].id,
    title: '프로젝트 2',
    color: '#FFE08C',
    isList: false,
    isFavorite: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'ed298270-fc55-45d7-bc41-bb63ffd09b4a',
    creatorId: users[1].id,
    title: '프로젝트 3',
    color: '#B7F0B1',
    isList: false,
    isFavorite: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const sections = [
  {
    id: '7abf0633-bce2-4972-9249-69f287db8a47',
    projectId: projects[0].id,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'efd8be46-ebc7-438d-931a-036a4b28789f',
    projectId: projects[1].id,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'cd57769e-7227-44da-bf6c-60f1a49ff6e3',
    projectId: projects[2].id,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const tasks = [
  {
    id: '13502adf-83dd-4e8e-9acf-5c5a0abd5b1b',
    sectionId: sections[0].id,
    parentId: null,
    title: '작업 1',
    dueDate: new Date(),
    position: 0,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'cd62f93c-9233-46a9-a5cf-ec18ad5a36f4',
    sectionId: sections[0].id,
    title: '작업 2',
    dueDate: new Date(),
    position: 1,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: '7d62f93c-9233-46a9-a5cf-ec18ad5a36f4',
    sectionId: sections[0].id,
    title: '작업 3',
    dueDate: new Date('2020-10-24T14:23:24.090Z'),
    position: 2,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: '8d62f93c-9233-46a9-a5cf-ec18ad5a36f4',
    sectionId: sections[0].id,
    parentId: '13502adf-83dd-4e8e-9acf-5c5a0abd5b1b',
    title: '작업 4',
    dueDate: new Date('2020-10-24T14:23:24.090Z'),
    position: 0,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: '9d62f93c-9233-46a9-a5cf-ec18ad5a36f4',
    sectionId: sections[0].id,
    parentId: '13502adf-83dd-4e8e-9acf-5c5a0abd5b1b',
    title: '작업 5',
    dueDate: new Date('2020-10-24T14:23:24.090Z'),
    position: 1,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: '568d0233-0e6e-4ff2-bdae-4c492e55f111',
    sectionId: sections[2].id,
    parentId: null,
    title: '작업 6',
    dueDate: new Date(),
    position: 1,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const comments = [
  {
    id: '6200bcb9-f871-439b-9507-57abbde3d468',
    content: '댓글 1',
    taskId: tasks[1].id,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'f7aeb64f-1aaf-4c0a-b962-dbfa6c4bb629',
    content: '댓글 2',
    taskId: tasks[1].id,
    createdAt: new Date('2020-12-13'),
    updatedAt: new Date('2020-12-13'),
  },
  {
    id: '47811107-b2ca-42f8-8a39-20e765694a4a',
    content: '댓글 3',
    taskId: tasks[2].id,
    createdAt: new Date('2020-12-13'),
    updatedAt: new Date('2020-12-13'),
  },
];

const bookmarks = [
  {
    id: 'cb8eb131-ad2e-4677-a4e5-c8ec078b28e8',
    url: 'https://www.uuidgenerator.net/version4',
    title: 'uuid 생성 사이트',
    taskId: tasks[0].id,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

module.exports = {
  users,
  projects,
  tasks,
  sections,
  comments,
  bookmarks,
  up: async () => {
    const queryInterface = sequelize.getQueryInterface();
    await queryInterface.bulkInsert('user', users, {});
    await queryInterface.bulkInsert('project', projects, {});
    await queryInterface.bulkInsert('section', sections, {});
    await queryInterface.bulkInsert('task', tasks, {});
    await queryInterface.bulkInsert('comment', comments, {});
    await queryInterface.bulkInsert('bookmark', bookmarks, {});
  },
  down: async () => {
    const queryInterface = sequelize.getQueryInterface();
    await queryInterface.bulkDelete('user', null, {});
    await queryInterface.bulkDelete('project', null, {});
    await queryInterface.bulkDelete('task', null, {});
    await queryInterface.bulkDelete('section', null, {});
    await queryInterface.bulkDelete('comment', null, {});
    await queryInterface.bulkDelete('bookmark', null, {});
  },
};
