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

module.exports = { isValidDueDate };
