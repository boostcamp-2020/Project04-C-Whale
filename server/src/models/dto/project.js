const { IsString, IsHexColor, MinLength, IsBoolean, IsEmpty } = require('class-validator');

class ProjectDto {
  @IsEmpty()
  id;

  @MinLength(1)
  @IsString()
  title;

  @IsHexColor()
  @IsString()
  color;

  @IsBoolean()
  isList;

  @IsBoolean()
  isFavorite;
}

module.exports = ProjectDto;
