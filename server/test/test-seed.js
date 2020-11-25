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
];

const priorities = [
  {
    id: 'c3bb8b39-cdad-4db4-ac02-ae506d30ba2a',
    title: '우선순위1',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: '248d7dd6-9f9b-4bff-b47d-43a8b07c9093',
    title: '우선순위2',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'ac7ac13c-53df-49a3-8617-654e23f3d043',
    title: '우선순위3',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: '936f1c1d-e169-47c4-b544-1f8a0aff0a8d',
    title: '우선순위4',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const projects = [
  {
    id: 'b7f253e5-7b6b-4ee2-b94e-369ffcdffb5f',
    creatorId: 'ff4dd832-1567-4d74-b41d-bd85e96ce329',
    title: '프로젝트 1',
    isList: true,
    isFavorite: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'f7605077-96ec-4365-88fc-a9c3af4a084e',
    creatorId: 'ff4dd832-1567-4d74-b41d-bd85e96ce329',
    title: '프로젝트 2',
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
];

const tasks = [
  {
    id: '13502adf-83dd-4e8e-9acf-5c5a0abd5b1b',
    projectId: projects[0].id,
    sectionId: sections[0].id,
    parentId: null,
    priorityId: priorities[0].id,
    title: '작업 1',
    dueDate: new Date(),
    position: 0,
    isDone: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'cd62f93c-9233-46a9-a5cf-ec18ad5a36f4',
    projectId: projects[0].id,
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
    projectId: projects[0].id,
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
    projectId: projects[0].id,
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
    projectId: projects[0].id,
    sectionId: sections[0].id,
    parentId: '13502adf-83dd-4e8e-9acf-5c5a0abd5b1b',
    title: '작업 5',
    dueDate: new Date('2020-10-24T14:23:24.090Z'),
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
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const labels = [
  {
    id: '54eefed3-3652-443f-85c9-7dfe87b23f82',
    color: 'red',
    title: '라벨 1',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const bookmarks = [
  {
    id: 'cb8eb131-ad2e-4677-a4e5-c8ec078b28e8',
    url: 'https://www.uuidgenerator.net/version4',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const alarms = [
  {
    id: 'e23a789c-ce37-45bd-bb6b-20602edfe221',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

module.exports = {
  users,
  priorities,
  projects,
  tasks,
  sections,
  comments,
  labels,
  bookmarks,
  alarms,
  up: async () => {
    const queryInterface = sequelize.getQueryInterface();
    await queryInterface.bulkInsert('user', users, {});
    await queryInterface.bulkInsert('priority', priorities, {});
    await queryInterface.bulkInsert('project', projects, {});
    await queryInterface.bulkInsert('section', sections, {});
    await queryInterface.bulkInsert('task', tasks, {});
    await queryInterface.bulkInsert('comment', comments, {});
    await queryInterface.bulkInsert('label', labels, {});
    await queryInterface.bulkInsert('bookmark', bookmarks, {});
    await queryInterface.bulkInsert('alarm', alarms, {});
  },
  down: async () => {
    const queryInterface = sequelize.getQueryInterface();
    await queryInterface.bulkDelete('user', null, {});
    await queryInterface.bulkDelete('priority', null, {});
    await queryInterface.bulkDelete('project', null, {});
    await queryInterface.bulkDelete('task', null, {});
    await queryInterface.bulkDelete('section', null, {});
    await queryInterface.bulkDelete('comment', null, {});
    await queryInterface.bulkDelete('label', null, {});
    await queryInterface.bulkDelete('bookmark', null, {});
    await queryInterface.bulkDelete('alarm', null, {});
  },
};