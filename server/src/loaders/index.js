const expressLoader = require('@loaders/express');
const sequelizeLoader = require('@loaders/sequelize');

const init = app => {
  expressLoader(app);
  sequelizeLoader();
};

module.exports = init;
