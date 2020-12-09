module.exports = {
  TYPE_ERROR: property => `${property} 타입이 올바르지 않습니다.`,
  UNNECESSARY_INPUT_ERROR: property => `불필요한 값이 포함되어 있습니다. => ${property}`,
  INVALID_INPUT_ERROR: property => `${property}값이 올바르지 않습니다.`,
  DUEDATE_ERROR: 'dueDate는 현재시간보다 이전을 설정할 수 없습니다.',
};
