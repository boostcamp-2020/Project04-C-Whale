const { IsString, IsEmpty, IsUrl, ValidateIf, MinLength, IsDefined } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class BookmarkDto {
  @IsEmpty()
  id;

  @IsDefined()
  @IsUrl({ require_protocol: true })
  @IsString()
  url;

  @ValidateIf(o => typeof o.title !== 'undefined') // validate if를 잘못 사용, 처음에 걸리는지 나중에 거리는지 체크
  @MinLength(1)
  @IsString()
  title;

  @IsEmpty({ message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  taskId;
}

module.exports = BookmarkDto;
// 기본형으로 쓸 수 있는 것은 기본형으로 쓰는 것을 추천
