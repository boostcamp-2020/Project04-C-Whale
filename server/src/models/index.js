const Sequelize = require('sequelize');
const applyAssociations = require('@models/associations');
const dbConnectionConfig = require('@config/db-config')[process.env.NODE_ENV];

const sequelize = new Sequelize(dbConnectionConfig);

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
