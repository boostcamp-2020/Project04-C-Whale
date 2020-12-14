const {
  IsString,
  ValidateIf,
  IsHexColor,
  IsUUID,
  MinLength,
  IsBoolean,
} = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class ProjectDto {
  @ValidateIf(o => !!o.id)
  @IsString()
  @IsUUID('4')
  id;

  @ValidateIf(o => !!o.title)
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('title') })
  @MinLength(1, { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('title') })
  title;

  @ValidateIf(o => !!o.color)
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('color') })
  @IsHexColor({ groups: ['created'], message: errorMessage.INVALID_INPUT_ERROR('color') })
  color;

  @ValidateIf(o => !!o.isList)
  @IsBoolean({ groups: ['create'], message: errorMessage.TYPE_ERROR('isList') })
  isList;

  @ValidateIf(o => !!o.isFavorite)
  @IsBoolean({ message: errorMessage.TYPE_ERROR('isFavorite') })
  isFavorite;
}

module.exports = ProjectDto;
