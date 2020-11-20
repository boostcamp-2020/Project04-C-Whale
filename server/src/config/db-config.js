require('dotenv').config();

const config = {
  development: {
    dialect: 'mysql',
    database: process.env.DB_LOCAL_NAME,
    username: process.env.DB_LOCAL_USER,
    password: process.env.DB_LOCAL_PASSWORD,
    host: process.env.DB_LOCAL_HOST,
    port: process.env.DB_LOCAL_PORT,
  },
  production: {
    dialect: 'mysql',
    database: process.env.DB_PRODUCTION_NAME,
    username: process.env.DB_PRODUCTION_USER,
    password: process.env.DB_PRODUCTION_PASSWORD,
    host: process.env.DB_PRODUCTION_HOST,
    port: process.env.DB_PRODUCTION_PORT,
  },
};

module.exports = config;
