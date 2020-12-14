const isValidURL = (input) => {
  try {
    new URL(input);
    return true;
  } catch (e) {
    return false;
  }
};

export { isValidURL };
