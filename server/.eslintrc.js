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
    'global-require': 0,
    'prettier/prettier': [
      'error',
      {
        endOfLine: 'auto',
      },
    ],
  },
  settings: {
    'import/resolver': {
      alias: [
        ['@root', './src'],
        ['@loaders', './src/loaders'],
        ['@models', './src/models'],
        ['@config', './src/config'],
        ['@test', './test'],
      ],
    },
  },
};
