const { IsString, IsEmpty, IsUrl, ValidateIf, MinLength, IsDefined } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class BookmarkDto {
  @IsEmpty({ message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  id;

  @IsDefined({ message: errorMessage.NECESSARY_INPUT_ERROR() })
  @IsUrl({ require_protocol: true }, { message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ message: errorMessage.TYPE_ERROR() })
  url;

  @ValidateIf(o => typeof o.title !== 'undefined') // validate if를 잘못 사용, 처음에 걸리는지 나중에 거리는지 체크
  @MinLength(1, { message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ message: errorMessage.TYPE_ERROR() })
  title;

  @IsEmpty({ message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  taskId;
}

module.exports = BookmarkDto;
// 기본형으로 쓸 수 있는 것은 기본형으로 쓰는 것을 추천
