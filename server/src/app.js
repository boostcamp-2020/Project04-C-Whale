require('module-alias/register');
require('dotenv').config();

const express = require('express');
const loader = require('@root/loaders');

const startServer = () => {
  const app = express();
  loader(app);
  const port = process.env.NODE_ENV === 'test' ? process.env.TEST_PORT : process.env.PORT;
  app.listen(port);
  return app;
};

module.exports = startServer();
