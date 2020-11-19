require('module-alias/register');
require('dotenv').config();

const express = require('express');
const logger = require('morgan');

const expressLoader = app => {
  const indexRouter = require('@root/routes');

  app.use(logger('dev'));
  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));

  app.use('/', indexRouter);
};

module.exports = expressLoader;
