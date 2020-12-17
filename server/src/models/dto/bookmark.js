const { IsString, IsEmpty, IsUrl, ValidateIf, MinLength, IsDefined } = require('class-validator');

class BookmarkDto {
  @IsEmpty()
  id;

  @IsDefined()
  @IsUrl({ require_protocol: true })
  @IsString()
  url;

  @ValidateIf(o => o.title !== undefined)
  @MinLength(1)
  @IsString()
  title;

  @IsEmpty()
  taskId;
}

module.exports = BookmarkDto;
