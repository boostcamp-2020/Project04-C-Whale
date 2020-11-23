const expressLoader = require('@loaders/express');
const sequelizeLoader = require('@loaders/sequelize');

const init = app => {
  expressLoader(app);
  if (process.env.NODE_ENV !== 'test') {
    sequelizeLoader();
  }
};

module.exports = init;
