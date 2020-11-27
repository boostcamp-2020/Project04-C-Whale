const Sequelize = require('sequelize');
const applyAssociations = require('@models/associations');
const dbConnectionConfig = require('@config/db-config')[process.env.NODE_ENV];

const fs = require('fs');

const path = require('path');

const basename = path.basename(__filename);

const sequelize = new Sequelize(dbConnectionConfig);

fs.readdirSync(__dirname)
  .filter(file => {
    return (
      file.indexOf('.') !== 0 &&
      file !== basename &&
      file !== 'associations.js' &&
      file.slice(-3) === '.js'
    );
  })
  .forEach(file => {
    // eslint-disable-next-line import/no-dynamic-require
    const modelDefiner = require(path.join(__dirname, file));
    modelDefiner(sequelize);
  });

applyAssociations(sequelize);

module.exports = sequelize;
