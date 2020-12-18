const plugins = [
  ['@babel/plugin-proposal-decorators', { legacy: true }],
  ['@babel/plugin-proposal-class-properties', { loose: true }],
  [
    'module-resolver',
    {
      alias: {
        '@root': './src',
        '@test': './test',
        '@config': './src/config',
        '@models': './src/models',
        '@loaders': './src/loaders',
        '@utils': './src/utils',
        '@routes': './src/routes',
        '@passport': './src/passport',
        '@services': './src/services',
        '@controllers': './src/controllers',
      },
    },
  ],
];

module.exports = { plugins };
