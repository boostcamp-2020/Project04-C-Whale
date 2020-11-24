const sequelize = require('@models');

const sequelizeLoader = async () => {
  if (process.env.NODE_ENV === 'test') {
    return;
  }

  try {
    await sequelize.sync({ alter: true });
  } catch (e) {
    process.exit(1);
  }
};

module.exports = sequelizeLoader;
