const { IsString, MinLength, IsEmpty, ValidateIf, IsInt } = require('class-validator');

class SectionDto {
  @IsEmpty()
  id;

  @MinLength(1)
  @IsString()
  title;

  @ValidateIf(o => o.position)
  @IsInt()
  position;
}

module.exports = SectionDto;
