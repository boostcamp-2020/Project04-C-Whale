module.exports = {
  transpileDependencies: ["vuetify"],
  lintOnSave: false,
  chainWebpack: (config) => {
    config.plugin("html").tap((args) => {
      args[0].title = "할고래DO";
      return args;
    });
  },
};
