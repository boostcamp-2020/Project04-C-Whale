const expressLoader = require('@loaders/express');
const sequelizeLoader = require('@loaders/sequelize');
const lastErrorhandler = require('@loaders/error-handler');

const init = app => {
  expressLoader(app);
  lastErrorhandler(app);
  if (process.env.NODE_ENV !== 'test') {
    sequelizeLoader();
  }
};

module.exports = init;
