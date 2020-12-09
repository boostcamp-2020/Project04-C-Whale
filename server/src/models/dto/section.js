const { IsUUID, IsString, IsInt, MinLength } = require('class-validator');
const errorMessage = require('@utils/error-messages');

class SectionDto {
  @IsUUID('4')
  id;

  @IsString({ groups: ['create', 'update'] }, { message: errorMessage.TYPE_ERROR('title') })
  @MinLength(
    1,
    { groups: ['create', 'update'] },
    { message: errorMessage.INVALID_INPUT_ERROR('title') },
  )
  title;

  @IsInt()
  position;
}

module.exports = SectionDto;
