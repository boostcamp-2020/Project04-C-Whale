const isValidDueDate = inputDate => {
  if (inputDate === undefined) {
    return true;
  }
  const dueDate = new Date(inputDate);
  const today = new Date(Date.now());

  return (
    dueDate.getFullYear() >= today.getFullYear() &&
    dueDate.getMonth() >= today.getMonth() &&
    dueDate.getDate() >= today.getDate()
  );
};

const getTodayString = () => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, '0');
  const mm = String(today.getMonth() + 1).padStart(2, '0'); // January is 0!
  const yyyy = today.getFullYear();

  return `${yyyy}-${mm}-${dd}`;
};

module.exports = { isValidDueDate, getTodayString };
