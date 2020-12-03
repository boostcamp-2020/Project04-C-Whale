const swapArrayItem = (arr, i, j) => {
  const copied = [...arr][j];
  arr[j] = arr[i];
  arr[i] = copied;
};

export default swapArrayItem;
