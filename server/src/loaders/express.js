const express = require('express');
const logger = require('morgan');
const passport = require('passport');
const passportConfig = require('@passport');

const expressLoader = app => {
  const indexRouter = require('@routes');

  app.use(logger('dev'));
  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));

  app.use(passport.initialize());
  passportConfig(passport);

  app.use('/api', indexRouter);
};

module.exports = expressLoader;
