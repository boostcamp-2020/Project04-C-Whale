const getTodayStartEnd = () => {
  const todayStart = new Date();
  const todayEnd = new Date();

  todayStart.setHours(0, 0, 0, 0);
  todayEnd.setHours(23, 59, 59, 999);

  return { todayStart, todayEnd };
};

module.exports = getTodayStartEnd;
