const isToday = (inputDate) => {
  const today = new Date(Date.now());

  const targetDate = new Date(inputDate);

  return (
    today.getFullYear() === targetDate.getFullYear() &&
    today.getMonth() === targetDate.getMonth() &&
    today.getDate() === targetDate.getDate()
  );
};

const isExpired = (inputDate) => {
  return new Date(inputDate) < new Date(new Date(Date.now()).toLocaleDateString());
};

const getTodayString = () => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, "0");
  const mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
  const yyyy = today.getFullYear();

  return `${yyyy}-${mm}-${dd}`;
};

export { isExpired, isToday, getTodayString };
