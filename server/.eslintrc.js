module.exports = {
  env: {
    browser: true,
    node: true,
    commonjs: true,
    es2021: true,
    'jest/globals': true,
  },
  plugins: ['prettier', 'jest'],
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
    'global-require': 'off',
    // 'no-console': 'off', // console 허용 유무에 따라 설정
  },
  settings: {
    'import/resolver': {
      alias: [
        ['@root', './server/src'],
        ['@loaders', './server/src/loaders'],
        ['@models', './server/src/models'],
        ['@config', './server/src/config'],
        ['@test', './server/test'],
        ['@utils', './server/src/utils'],
      ],
    },
  },
};
