const extensionId = process.env.VUE_APP_EXTENSION_ID;
const port = whale.runtime.connect(extensionId, { name: `greetings` });

const getCurrentTabUrl = (cb) => {
  whale.runtime.sendMessage(extensionId, "getCurrentTabUrl", cb);
};

export default { test, getCurrentTabUrl };
