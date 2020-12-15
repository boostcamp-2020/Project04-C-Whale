whale.contextMenus.create({
  id: 'ADD_TASK',
  title: `할고래DO 할일로 추가`,
  contexts: ['selection'],
});

whale.storage.sync.get((alarms) => {
  console.log(Date.now());
  Object.values(alarms).forEach((alarm) => {
    const isOld = Date.now() > alarm.fireTime;

    if (isOld) {
      console.log('hhh');
      return;
    }
    whale.alarms.create(alarm.taskTitle, {
      when: alarm.fireTime,
    });
  });
});

whale.alarms.onAlarm.addListener((alarm) => {
  whale.notifications.create({
    title: `할일: ${alarm.name}`,
    message: 'CLICK !!',
    iconUrl: 'images/icon.png',
    type: 'basic',
  });
});

whale.notifications.onClicked.addListener(() => {
  whale.sidebarAction.show();
});

let handlerToRemove;

whale.runtime.onConnectExternal.addListener((port) => {
  const handleOnClicked = (info) => {
    if (info.menuItemId == 'ADD_TASK') {
      port.postMessage(info);
    }
  };

  whale.contextMenus.onClicked.removeListener(handlerToRemove);
  whale.contextMenus.onClicked.addListener(handleOnClicked);
  handlerToRemove = handleOnClicked;
});

whale.runtime.onMessageExternal.addListener(
  (message, _sender, sendResponse) => {
    switch (message.type) {
      case 'getCurrentTabUrl':
        whale.tabs.query({ active: true, lastFocusedWindow: true }, (tabs) => {
          const currentTab = tabs[0];
          console.log(currentTab);
          sendResponse({ url: currentTab.url, title: currentTab.title });
        });
        break;

      case 'createAlarm':
        const { taskTitle, fireTime } = message.data;

        whale.storage.sync.set({ [taskTitle]: { taskTitle, fireTime } });

        whale.alarms.create(taskTitle, {
          when: fireTime,
        });

      case 'createBookmark':
        const { folderTitle, bookmarks } = message.data;

        whale.bookmarks.create(
          {
            parentId: '1',
            title: folderTitle,
          },
          (newFolder) => {
            bookmarks.forEach((bookmark) => {
              whale.bookmarks.create({
                parentId: newFolder.id,
                title: bookmark.title,
                url: bookmark.url,
              });
            });
          }
        );
        sendResponse('북마크가 추가되었습니다.');
        break;
    }
  }
);
