const sequelize = require('@models');

const sequelizeLoader = () => {
  // const useInit = process.env.INIT_DB === 'use';
  sequelize.sync({ force: true });
};

module.exports = sequelizeLoader;
