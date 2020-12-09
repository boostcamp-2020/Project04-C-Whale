const {
  IsString,
  IsBoolean,
  MinLength,
  IsOptional,
  IsEmpty,
  IsNotEmpty,
} = require('class-validator');
const errorMessage = require('@utils/error-messages');

class CommentDto {
  @IsEmpty({ groups: ['create', 'update'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  id;

  @IsNotEmpty({ groups: ['update'], message: errorMessage.NECESSARY_INPUT_ERROR('content') })
  @IsString({ groups: ['create', 'update'], message: errorMessage.TYPE_ERROR('content') })
  @MinLength(1, {
    groups: ['create', 'update'],
    message: errorMessage.INVALID_INPUT_ERROR('content'),
  })
  content;

  @IsNotEmpty({ groups: ['update'], message: errorMessage.NECESSARY_INPUT_ERROR('isImage') })
  @IsOptional({ groups: ['create'] })
  @IsBoolean({ groups: ['create', 'update'], message: errorMessage.TYPE_ERROR('isImage') })
  isImage;

  taskId;
}

module.exports = CommentDto;
