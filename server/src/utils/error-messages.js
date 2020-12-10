module.exports = {
  TYPE_ERROR: property => `${property} 타입이 올바르지 않습니다.`,
  NECESSARY_INPUT_ERROR: property => `${property}을(를) 입력해주세요.`,
  UNNECESSARY_INPUT_ERROR: property => `불필요한 값이 포함되어 있습니다. => ${property}`,
  INVALID_INPUT_ERROR: property => `${property}값이 올바르지 않습니다.`,
  NOT_FOUND_ERROR: property => `존재하지 않는 ${property}입니다.`,
  WRONG_RELATION_ERROR: property => `요청하신 데이터의 연관관계가 잘못됐습니다. ${property}`,
  FORBIDDEN_ERROR: property => `${property}에 접근 권한이 없습니다.`,
  DUEDATE_ERROR: 'dueDate는 현재시간보다 이전을 설정할 수 없습니다.',
};
