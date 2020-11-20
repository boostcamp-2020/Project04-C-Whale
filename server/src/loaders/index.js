const expressLoader = require('@loaders/express');
const sequelizeLoader = require('@loaders/sequelize');

const init = async app => {
  expressLoader(app);
  await sequelizeLoader();
};

module.exports = init;
