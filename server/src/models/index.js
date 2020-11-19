const Sequelize = require('sequelize');
const applyAssociations = require('@models/associations');
const dbConnectionConfig = require('@config/db-config');

const sequelize = new Sequelize(dbConnectionConfig);

(async () => {
  try {
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
})();

const modelDefiners = [
  require('@models/user'),
  require('@models/project'),
  require('@models/section'),
  require('@models/task'),
  require('@models/comment'),
  require('@models/priority'),
  require('@models/label'),
  require('@models/bookmark'),
  require('@models/alarm'),
];

modelDefiners.forEach(modelDefiner => {
  modelDefiner(sequelize);
});

applyAssociations(sequelize);

module.exports = sequelize;
