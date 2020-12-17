const { IsString, ValidateIf, IsHexColor, MinLength, IsBoolean } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class ProjectDto {
  id;

  @ValidateIf(o => !!o.title)
  @MinLength(1, { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR() })
  title;

  @ValidateIf(o => !!o.color)
  @IsHexColor({ groups: ['created'], message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR() })
  color;

  @ValidateIf(o => !!o.isList)
  @IsBoolean({ groups: ['create'], message: errorMessage.TYPE_ERROR() })
  isList;

  @ValidateIf(o => !!o.isFavorite)
  @IsBoolean({ message: errorMessage.TYPE_ERROR() })
  isFavorite;
}

module.exports = ProjectDto;
