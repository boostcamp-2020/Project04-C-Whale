const { IsUUID, IsString, IsInt, MinLength } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class SectionDto {
  @IsUUID('4')
  id;

  @IsString({ groups: ['create', 'update'] }, { message: errorMessage.TYPE_ERROR() })
  @MinLength(1, { groups: ['create', 'update'] }, { message: errorMessage.INVALID_INPUT_ERROR() })
  title;

  @IsInt()
  position;
}

module.exports = SectionDto;
