const isToday = (inputDate) => {
  const today = new Date(Date.now());

  const targetDate = new Date(inputDate);

  return (
    today.getFullYear() === targetDate.getFullYear() &&
    today.getMonth() === targetDate.getMonth() &&
    today.getDate() === targetDate.getDate()
  );
};

export default { isToday };
