const {
  IsInt,
  IsString,
  IsBoolean,
  MinLength,
  IsDateString,
  IsUUID,
  IsOptional,
  IsEmpty,
} = require('class-validator');
const errorMessage = require('@utils/error-messages');

class CommentDto {
  @IsEmpty({ groups: ['create'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  @IsString()
  @IsUUID()
  id;

  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('content') })
  @MinLength(1, { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('content') })
  content;

  @IsString()
  @IsUUID()
  taskId;
}

module.exports = CommentDto;
