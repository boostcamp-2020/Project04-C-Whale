const { IsString, IsEmpty, IsUrl, ValidateIf, MinLength, IsDefined } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class BookmarkDto {
  // bookmark는 update가 없으므로, create 때만 검증
  @IsEmpty({ message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  id;

  @IsDefined({ message: errorMessage.NECESSARY_INPUT_ERROR('url') })
  @IsString({ message: errorMessage.TYPE_ERROR('url') })
  @IsUrl({ require_protocol: true }, { message: errorMessage.INVALID_INPUT_ERROR('url') })
  url;

  @ValidateIf(o => typeof o.title !== 'undefined')
  @IsString({ message: errorMessage.TYPE_ERROR('title') })
  @MinLength(1, { message: errorMessage.INVALID_INPUT_ERROR('title') })
  title;

  @IsEmpty({ message: errorMessage.UNNECESSARY_INPUT_ERROR('taskId') })
  taskId;
}

module.exports = BookmarkDto;
