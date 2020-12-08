const {
  IsString,
  IsNotEmpty,
  ValidateIf,
  IsHexColor,
  IsUUID,
  MinLength,
  IsBoolean,
} = require('class-validator');
const errorMessage = require('@models/dto/error-messages');

class ProjectDto {
  @ValidateIf(o => !!o.id)
  @IsString()
  @IsUUID('4')
  id;

  @ValidateIf(o => !!o.title)
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('제목') })
  @MinLength(1, { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('제목') })
  title;

  @ValidateIf(o => !!o.color)
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('색상') })
  @IsHexColor({ groups: ['created'], message: errorMessage.INVALID_INPUT_ERROR('색상') })
  color;

  @ValidateIf(o => !!o.isList)
  @IsBoolean({ groups: ['create'], message: errorMessage.TYPE_ERROR('목록') })
  isList;

  @ValidateIf(o => !!o.isFavorite)
  @IsBoolean({ message: errorMessage.TYPE_ERROR('즐겨찾기') })
  isFavorite;
}

module.exports = ProjectDto;
