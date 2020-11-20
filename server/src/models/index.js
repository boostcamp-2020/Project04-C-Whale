const Sequelize = require('sequelize');
const applyAssociations = require('@models/associations');
const dbConnectionConfig = require('@config/db-config');
const fs = require('fs');
const path = require('path');
const basename = path.basename(__filename);

const sequelize = new Sequelize(dbConnectionConfig);

(async () => {
  try {
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
})();

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
    const modelDefiner = require(path.join(__dirname, file));
    modelDefiner(sequelize);
  });

applyAssociations(sequelize);

module.exports = sequelize;
