const extensionId = process.env.VUE_APP_EXTENSION_ID;
const port = whale.runtime.connect(extensionId, { name: `greetings` });

const getCurrentTabUrl = (cb) => {
  whale.runtime.sendMessage(extensionId, { type: "getCurrentTabUrl" }, cb);
};

const createBookmark = (data, cb) => {
  whale.runtime.sendMessage(extensionId, { type: "createBookmark", data }, cb);
};

export default { getCurrentTabUrl, createBookmark };
