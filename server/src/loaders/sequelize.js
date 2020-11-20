const sequelize = require('@models');

const sequelizeLoader = async () => {
  // const useInit = process.env.INIT_DB === 'use';
  try {
    await sequelize.sync({ force: true });
  } catch (e) {
    process.exit(1);
  }
};

module.exports = sequelizeLoader;
