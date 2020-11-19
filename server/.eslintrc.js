module.exports = {
  env: {
    browser: true,
    node: true,
    commonjs: true,
    es2021: true,
  },
  plugins: ['prettier'],
  extends: ['airbnb-base', 'eslint-config-prettier', 'prettier'],
  parserOptions: {
    ecmaVersion: 12,
  },
  rules: {
    'prettier/prettier': [
      'error',
      {
        endOfLine: 'auto',
      },
    ],
  },
};
