require('module-alias/register');
require('dotenv').config();

const express = require('express');
const loader = require('@root/loaders');

const startServer = () => {
  const app = express();
  loader(app);
  module.exports = app;
};

startServer();
