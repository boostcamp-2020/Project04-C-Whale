module.exports = {
  transpileDependencies: ["vuetify"],
  chainWebpack: (config) => {
    config.module.rule('eslint').use('eslint-loader').tap((options) => {
      options.fix = true;
      return options;
    })
  }
};
