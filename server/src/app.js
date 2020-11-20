require('module-alias/register');
const express = require('express');
const loader = require('@root/loaders');

const startServer = async () => {
  const app = express();
  await loader(app);
  module.exports = app;
  app.listen(process.env.PORT);
};

startServer();
