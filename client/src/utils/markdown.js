const getMarkDownUrl = (title, url) => {
  return `[${title}](${url})`;
};

const isValidURLMarkdown = (input) => {
  try {
    const [possibleTitle, possibleURL] = input.split("]");
    if (!possibleTitle[0] === "[") return false;
    if (possibleTitle.substring(1).length === 0) return false;
    if (!(possibleURL[0] === "(") || !(possibleURL[possibleURL.length - 1] === ")")) return false;

    new URL(possibleURL.substring(1, possibleURL.length - 1));
    return true;
  } catch (e) {
    return false;
  }
};

const getBookmark = (input) => {
  const [possibleTitle, possibleURL] = input.split("]");
  return {
    title: possibleTitle.substring(1),
    url: possibleURL.substring(1, possibleURL.length - 1),
  };
};

export { getMarkDownUrl, isValidURLMarkdown, getBookmark };
