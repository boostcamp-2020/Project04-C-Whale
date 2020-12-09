whale.runtime.onConnectExternal.addListener((port) => {
  const contextAddTask = (info) => {
    port.postMessage(info);
  };

  whale.contextMenus.create({
    id: '123',
    title: `할고래DO 할일로 추가`,
    contexts: ['selection'],
  });

  whale.contextMenus.onClicked.addListener((info) => {
    if (info.menuItemId == '123') {
      port.postMessage(info);
    }
  });
});

whale.runtime.onMessageExternal.addListener((message, sender, sendResponse) => {
  switch (message) {
    case 'getCurrentTabUrl':
      whale.tabs.query({ active: true, lastFocusedWindow: true }, (tabs) => {
        const currentTab = tabs[0];
        sendResponse({ url: currentTab.url, title: currentTab.title });
      });
      break;
  }
});
