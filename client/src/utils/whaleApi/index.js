import store from "@/store";
import { getTodayString } from "@/utils/date";
import { getMarkDownUrl } from "@/utils/markdown";

const extensionId = process.env.VUE_APP_EXTENSION_ID;

const isWhale = window.whale ? true : false;
if (isWhale) {
  const port = whale.runtime?.connect(extensionId, { name: "Halgoraedo" });

  if (port) {
    port.onMessage.addListener(async (info) => {
      const defaultProject = store.getters.managedProject;

      const result = await store.dispatch("addTask", {
        title: getMarkDownUrl(info.selectionText),
        dueDate: getTodayString(),
        projectId: defaultProject.id,
        sectionId: defaultProject.defaultSectionId,
      });
    });
  }
}

const getCurrentTabUrl = (cb) => {
  isWhale ? whale.runtime.sendMessage(extensionId, { type: "getCurrentTabUrl" }, cb) : undefined;
};

const createAlarm = (data) => {
  isWhale ? whale.runtime.sendMessage(extensionId, { type: "createAlarm", data }) : undefined;
};

const createBookmark = (data, cb) => {
  isWhale
    ? whale.runtime.sendMessage(extensionId, { type: "createBookmark", data }, cb)
    : undefined;
};

export default { getCurrentTabUrl, createAlarm, createBookmark, isWhale };
