const { IsString, IsBoolean, IsOptional, IsEmpty, MinLength } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class CommentDto {
  @IsEmpty({ groups: ['create', 'update'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  id;

  @IsString({ groups: ['create', 'update'], message: errorMessage.TYPE_ERROR('content') })
  @MinLength(1, {
    groups: ['create', 'update'],
    message: errorMessage.INVALID_INPUT_ERROR('content'),
  })
  content;

  @IsOptional({ groups: ['create'] })
  @IsBoolean({ groups: ['create', 'update'], message: errorMessage.TYPE_ERROR('isImage') })
  isImage;

  taskId;
}

module.exports = CommentDto;
