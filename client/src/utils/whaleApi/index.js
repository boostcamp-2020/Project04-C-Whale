import store from '../../store';
import { getTodayString } from "../../utils/date";
import { getMarkDownUrl } from "../../utils/markdown";

const extensionId = process.env.VUE_APP_EXTENSION_ID;
const port = whale.runtime.connect(extensionId, { name: 'addTask' });

const getCurrentTabUrl = (cb) => {
  whale.runtime.sendMessage(extensionId, {type:"getCurrentTabUrl"}, cb);
};

port.onMessage.addListener(async info => {
  const defaultProject = store.getters.managedProject;

  const result = await store.dispatch('addTask', {
    title: getMarkDownUrl(info.selectionText),
    dueDate: getTodayString(),
    projectId: defaultProject.id,
    sectionId: defaultProject.defaultSectionId,
  })
})

const createAlarm = (data) => {
  whale.runtime.sendMessage(extensionId, {type:"createAlarm", data});
}

export { getCurrentTabUrl, createAlarm };
