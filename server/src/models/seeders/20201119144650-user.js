const { v4: uuidv4 } = require('uuid');

const users = [
  {
    email: 'kyle@example.com',
    name: 'kyle',
    provider: 'naver',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const labels = [
  {
    id: uuidv4(),
    title: 'label1',
    color: '#FFFFFF',
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkInsert('user', users, {});
    await queryInterface.bulkInsert('label', labels, {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('user', null, {});
    await queryInterface.bulkDelete('label', null, {});
  },
};
