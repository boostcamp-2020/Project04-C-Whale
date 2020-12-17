const { IsString, IsEmpty, MinLength } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class CommentDto {
  @IsEmpty({ groups: ['create', 'update'], message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  id;

  @IsString({ groups: ['create', 'update'], message: errorMessage.TYPE_ERROR() })
  @MinLength(1, {
    groups: ['create', 'update'],
    message: errorMessage.INVALID_INPUT_ERROR(),
  })
  content;

  @IsEmpty({
    groups: ['update'],
    message: errorMessage.UNNECESSARY_INPUT_ERROR(),
  })
  taskId;
}

module.exports = CommentDto;
