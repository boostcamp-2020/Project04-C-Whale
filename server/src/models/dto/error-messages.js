const missingProperty = property => `${property}를 입력해주세요`;
const wrongProperty = property => `${property}값이 올바르지 않습니다`;

const beforeDueDate = 'dueDate는 현재시간보다 이전을 설정할 수 없습니다.';

module.exports = { missingProperty, wrongProperty, beforeDueDate };
