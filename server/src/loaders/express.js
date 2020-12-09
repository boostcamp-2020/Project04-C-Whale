const express = require('express');
const logger = require('morgan');
const cors = require('cors');
const passport = require('passport');
const passportConfig = require('@passport');

const expressLoader = app => {
  const indexRouter = require('@routes');

  app.use(logger('dev'));
  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));
  app.use(cors()); // TODO localhost:8080 만 허용하도록 변경해야 함

  app.use(passport.initialize());
  passportConfig(passport);

  app.use('/api', indexRouter);
};

module.exports = expressLoader;
