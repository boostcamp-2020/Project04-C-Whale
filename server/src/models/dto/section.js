const { IsUUID, IsString, IsInt, MinLength } = require('class-validator');
const errorMessage = require('@models/dto/error-messages');

class SectionDto {
  @IsUUID('4')
  id;

  @IsString({ groups: ['create', 'update'] }, { message: errorMessage.wrongProperty('title') })
  @MinLength(1, { groups: ['create', 'update'] }, { message: errorMessage.wrongProperty('title') })
  title;

  @IsInt()
  position;
}

module.exports = SectionDto;
