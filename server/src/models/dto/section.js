const { IsUUID, IsString, IsInt, MinLength } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class SectionDto {
  @IsUUID('4')
  id;

  @MinLength(1, { groups: ['create', 'update'] }, { message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ groups: ['create', 'update'] }, { message: errorMessage.TYPE_ERROR() })
  title;

  @IsInt()
  position;
}

module.exports = SectionDto;
